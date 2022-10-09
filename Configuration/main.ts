import { Construct } from 'constructs';
import { App, Chart, ChartProps, ApiObject } from 'cdk8s';
import { Deployment } from 'cdk8s-plus-22';

export class MyChart extends Chart {
  constructor(scope: Construct, id: string, props: ChartProps = { }) {
    super(scope, id, props);

  }
}

const app = new App();
const tekton_chart = new MyChart(app, 'tekton');
const wordpress_chart = new MyChart(app, 'wordpress');
const mysql_chart = new MyChart(app, 'mysql');

new Deployment(wordpress_chart, 'wordpress', {
  containers: [ { image: 'aymanzahran/wordpress:4.8-apache' } ],
  replicas: 3,
});


new Deployment(mysql_chart, 'mysql', {
  containers: [ { image: 'aymanzahran/wordpress:4.8-apache' } ],
  replicas: 3,
});

new ApiObject(tekton_chart, 'tekton', {
  apiVersion: 'v1',
  kind: 'Task'
});

app.synth();
