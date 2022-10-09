import { App, Stack, StackProps, aws_eks, aws_ec2 } from 'aws-cdk-lib';
import { Construct } from 'constructs';

export class MyStack extends Stack {
  constructor(scope: Construct, id: string, props: StackProps = {}) {
    super(scope, id, props);

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