import { App, Stack, StackProps, aws_eks, aws_ec2 } from 'aws-cdk-lib';
import { Construct } from 'constructs';

export class MyStack extends Stack {
  constructor(scope: Construct, id: string, props: StackProps = {}) {
    super(scope, id, props);

    const GIT_REPO = 'https://github.com/AymanZahran/IpadGitpodWorkspace';

    const cluster = new aws_eks.Cluster(this, 'HelloEKS', {
      version: aws_eks.KubernetesVersion.V1_21,
    });

    cluster.addNodegroupCapacity('node-group', {
      instanceTypes: [new aws_ec2.InstanceType('m5.xlarge')],
      nodegroupName: 'node-group',
      maxSize: 3,
      minSize: 3,
      desiredSize: 3,
    });

    cluster.addManifest('create-argo-namespace', {
      apiVersion: 'v1',
      kind: 'namespace',
      metadata: {
        name: 'argocd',
      },
    });

    cluster.addManifest('install-argo-crd', {
      apiVersion: 'kustomize.config.k8s.io/v1beta1',
      kind: 'Kustomization',
      metadata: {
        name: 'kustomization',
      },
      spec: {
        resources: [
          'https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml',
        ],
      },
    });

    cluster.addManifest('install-argo-application', {
      apiVersion: 'v1',
      kind: 'Application',
      metadata: {
        name: 'argocd-application',
        namespace: 'argocd',
      },
      spec: {
        project: 'default',
        source: {
          repoURL: GIT_REPO,
          targetRevision: 'HEAD',
          path: 'Configuration/dist',
        },
        destination: {
          server: 'https://kubernetes.default.svc',
          namespace: 'argocd',
        },
        syncPolicy: {
          syncOptions: [{ CreateNamespace: true }],
          automated: {
            prune: true,
            selfHeal: true,
          },
        },
      },
    });
  }
}

// for development, use account/region from cdk cli
const devEnv = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new App();

new MyStack(app, 'Infrastructure-dev', { env: devEnv });
// new MyStack(app, 'Infrastructure-prod', { env: prodEnv });

app.synth();