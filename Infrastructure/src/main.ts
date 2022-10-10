// import 'source-map-support/register';
// import { App, Stack, StackProps, aws_eks, aws_ec2 } from 'aws-cdk-lib';
import { KubernetesManifest } from "aws-cdk-lib/aws-eks";
import { App, Stack, StackProps } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as blueprints from '@aws-quickstart/eks-blueprints';

export class MyStack extends Stack {
  constructor(scope: Construct, id: string, props: StackProps = {}) {
    super(scope, id, props);

    const addOns: Array<blueprints.ClusterAddOn> = [
      new blueprints.addons.ArgoCDAddOn,
      new blueprints.addons.CalicoAddOn,
      new blueprints.addons.MetricsServerAddOn,
      new blueprints.addons.ClusterAutoScalerAddOn,
      new blueprints.addons.ContainerInsightsAddOn,
      new blueprints.addons.AwsLoadBalancerControllerAddOn(),
      new blueprints.addons.VpcCniAddOn(),
      new blueprints.addons.CoreDnsAddOn(),
      new blueprints.addons.KubeProxyAddOn(),
      new blueprints.addons.XrayAddOn()
    ];

    new blueprints.EksBlueprint(app, { id: 'east-test-1', addOns}, props)


    // const cluster = new aws_eks.Cluster(this, 'HelloEKS', {
    //   version: aws_eks.KubernetesVersion.V1_21,
    // });

    // cluster.addNodegroupCapacity('node-group', {
    //   instanceTypes: [new aws_ec2.InstanceType('m5.xlarge')],
    //   nodegroupName: 'node-group',
    //   maxSize: 3,
    //   minSize: 3,
    //   desiredSize: 3,
    // });
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