#!/bin/bash

ACCOUNT_ID=`aws --profile=$Profile sts get-caller-identity --query "Account" --output text`
export ClusterName=EKS-Cluster

# To Create EKS Cluster
eksctl create cluster -f EKS-Cluster.yaml
# To Update EKS Cluster
eksctl upgrade cluster -f EKS-Cluster.yaml
# To Update Cluster Logging
eksctl utils update-cluster-logging --config-file EKS-Cluster.yaml --approve

## Creating an IAM OIDC provider for your cluster
OID=`aws eks describe-cluster --name EKS-Cluster --query "cluster.identity.oidc.issuer" --output text | awk -F"/" '{ print $5 }'`
aws iam list-open-id-connect-providers | grep -i $OID
eksctl utils associate-iam-oidc-provider --cluster EKS-Cluster --approve

## Set up the CloudWatch agent to collect cluster metrics
# Step 1: Create a namespace for CloudWatch
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml
# Step 2: Create a service account in the cluster
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-serviceaccount.yaml
# Step 3: Create a ConfigMap for the CloudWatch agent
sudo curl -O https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-configmap.yaml
# Step 4: Edit the downloaded YAML file with the Cluster Name
sed -i s/"{{cluster_name}}"//g 
kubectl apply -f cwagent-configmap.yaml
# Step 5: Deploy the CloudWatch agent as a DaemonSet
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-daemonset.yaml

## Set up the FluentBit to send logs to Cloudwatch
# Step 1: Create a namespace for CloudWatch
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml
# Step 2: Run the following command to create a ConfigMap named cluster-info with the cluster name and the Region to send logs to. Replace cluster-name and cluster-region with your cluster's name and Region.
ClusterName=EKS-Cluster
RegionName=us-east-1
FluentBitHttpPort='2020'
FluentBitReadFromHead='Off'
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
kubectl create configmap fluent-bit-cluster-info \
--from-literal=cluster.name=${ClusterName} \
--from-literal=http.server=${FluentBitHttpServer} \
--from-literal=http.port=${FluentBitHttpPort} \
--from-literal=read.head=${FluentBitReadFromHead} \
--from-literal=read.tail=${FluentBitReadFromTail} \
--from-literal=logs.region=${RegionName} -n amazon-cloudwatch
# Step 3: Download and deploy the Fluent Bit daemonset to the cluster by running one of the following commands.
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluent-bit/fluent-bit.yaml

## Installing and Deploying the Kubernetes Dashboard
# Step 1: Deploying the Dashboard UI 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
# Step 2: Create an admin user account
kubectl apply -f admin-service-account.yaml
# Step 3: access the dashboard
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
# Step 4: Accessing the Dashboard UI 
kubectl proxy
# Kubectl will make Dashboard available at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.

## Install Metric Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

## Networking Plugin (Calico)
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-crs.yaml

## AWS Load Balancer Controller
# Download an IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behalf
curl -o AWSLoadBalancerControllerIAMPolicy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.3/docs/install/iam_policy.json
# Create an IAM policy using the policy downloaded in the previous step.
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://AWSLoadBalancerControllerIAMPolicy.json
# Create an IAM role. Create a Kubernetes service account named aws-load-balancer-controller in the kube-system namespace for the AWS Load Balancer Controller and annotate the Kubernetes service account with the name of the IAM role.# Create a role for the AWS Load Balancer Controller that has the IAM policy attached.
eksctl create iamserviceaccount \
  --cluster=EKS-Cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name "AmazonEKSLoadBalancerControllerRole" \
  --attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
# Add the eks-charts repository.
helm repo add eks https://aws.github.io/eks-charts
# Update your local repo to make sure that you have the most recent charts.
helm repo update
# Install the AWS Load Balancer Controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=region-code=us-east-1
# Verify that the controller is installed.
kubectl get deployment -n kube-system aws-load-balancer-controller


## Cluster Autoscaler
# Create Cluster Autoscaler Policy
aws iam create-policy \
    --policy-name AmazonEKSClusterAutoscalerPolicy \
    --policy-document file://AmazonEKSClusterAutoscalerPolicy.json
# Create Cluster Autoscaler Role
eksctl create iamserviceaccount \
  --cluster=EKS-Cluster \
  --namespace=kube-system \
  --name=cluster-autoscaler \
  --attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/AmazonEKSClusterAutoscalerPolicy \
  --override-existing-serviceaccounts \
  --approve
# Download the Cluster Autoscaler YAML file.
curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
# Modify the YAML file and replace <YOUR CLUSTER NAME> with your cluster name.
# Deploy the Cluster Autoscaler
kubectl apply -f cluster-autoscaler-autodiscover.yaml
# Annotate the cluster-autoscaler service account with the ARN of the IAM role that you created previously
kubectl annotate serviceaccount cluster-autoscaler \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::$ACCOUNT_ID:role/AmazonEKSClusterAutoscalerRole
# Patch the deployment to add the cluster-autoscaler.kubernetes.io/safe-to-evict annotation to the Cluster Autoscaler pods 
| kubectl patch deployment cluster-autoscaler \
    -n kube-system \
    -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
# Edit the Cluster Autoscaler deployment (Add Commands --balance-similar-node-groups and --skip-nodes-with-system-pods=false)
kubectl -n kube-system edit deployment.apps/cluster-autoscaler
# Set the Cluster Autoscaler image tag to the version required
kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v1.21.3
# View your Cluster Autoscaler logs
kubectl -n kube-system logs -f deployment.apps/cluster-autoscaler

## EBS CSI Driver
# Create an IAM role and attach the required AWS managed policy
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster EKS-Cluster \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_DriverRole
# Adding the Amazon EBS CSI add-on
eksctl create addon --name aws-ebs-csi-driver --cluster EKS-Cluster --service-account-role-arn arn:aws:iam::$ACCOUNT_ID:role/AmazonEKS_EBS_CSI_DriverRole --force
# Check the current version of your Amazon EBS CSI add-on
eksctl get addon --name aws-ebs-csi-driver --cluster EKS-Cluster
# Updating the Amazon EBS CSI driver as an Amazon EKS add-on
eksctl update addon \
  --name aws-ebs-csi-driver \
  --version v1.10.0-eksbuild.1 \
  --cluster EKS-Cluster \
  --force

## EFS CSI Driver
# Create an IAM role and attach the required policy
sudo curl -o AmazonEKS_EFS_CSI_Driver_Policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json
aws iam create-policy \
    --policy-name AmazonEKS_EFS_CSI_Driver_Policy \
    --policy-document file://AmazonEKS_EFS_CSI_Driver_Policy.json
eksctl create iamserviceaccount \
    --cluster EKS-Cluster \
    --namespace kube-system \
    --name efs-csi-controller-sa \
    --attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AmazonEKS_EFS_CSI_Driver_Policy \
    --approve \
    --region us-east-1
# Adding the Amazon EFS CSI add-on
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository=602401143452.dkr.ecr.region-code.amazonaws.com/eks/aws-efs-csi-driver \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa
# Verify Installation
kubectl get pod -n kube-system -l "app.kubernetes.io/name=aws-efs-csi-driver,app.kubernetes.io/instance=aws-efs-csi-driver"

## Clean Up
# To Delete NodeGroup
eksctl delete nodegroup --name ManagedNodeGroup --cluster EKS-Cluster --drain=false --disable-eviction
eksctl delete nodegroup --name MixedManagedNodeGroup --cluster EKS-Cluster --drain=false --disable-eviction
eksctl delete fargateprofile --name FargateManagedInstances --cluster EKS-Cluster

# To Delete EKS Cluster
eksctl delete cluster --name EKS-Cluster