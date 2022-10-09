import { App, Chart, ChartProps, ApiObject } from 'cdk8s';
import { Deployment } from 'cdk8s-plus-22';
import { Construct } from 'constructs';

export class MyChart extends Chart {
  constructor(scope: Construct, id: string, props: ChartProps = { }) {
    super(scope, id, props);

  }
}

const app = new App();
const argo_chart = new MyChart(app, 'argo');
const tekton_chart = new MyChart(app, 'tekton');
const wordpress_chart = new MyChart(app, 'wordpress');
const mysql_chart = new MyChart(app, 'mysql');

new ApiObject(argo_chart, 'hi', {
  apiVersion: 'v1',
  kind: 'Application',
  metadata: {
    name: 'argocd-application',
  },
  spec: {
    project: 'default',
    source: {
      repoURL: 'https://github.com/AymanZahran/IpadGitpodWorkspace',
      targetRevision: 'HEAD',
      path: 'Configuration/dist',
    },
    destination: {
      server: 'https://kubernetes.default.svc',
      namespace: 'argocd',
    },
    syncPolicy: {
      syncOptions: [
        { CreateNamespace: true },
      ],
      automated: {
        prune: true,
        selfHeal: true,
      },
    },
  },
});

new ApiObject(tekton_chart, 'hi', {
  apiVersion: 'v1',
  kind: 'Task',
  metadata: { name: 'hi' },
  spec: {
    steps: [
      {
        name: 'hi',
        image: 'ubuntu',
        script: 'echo "Hello World!"',
      },
    ],
  },
});

new ApiObject(tekton_chart, 'bye', {
  apiVersion: 'v1',
  kind: 'Task',
  metadata: { name: 'bye' },
  spec: {
    params: [
      {
        name: 'username',
        type: 'string',
      },
    ],
    steps: [
      {
        name: 'bye',
        image: 'ubuntu',
        script: 'echo "Bye World!"',
      },
    ],
  },
});

new ApiObject(tekton_chart, 'hi-bye', {
  apiVersion: 'v1',
  kind: 'Pipeline',
  metadata: { name: 'hi-bye' },
  spec: {
    params: [
      {
        name: 'username',
        type: 'string',
      },
    ],
    tasks: [
      {
        name: 'hi',
        taskRef: { name: 'hi' },
      },
      {
        name: 'bye',
        taskRef: { name: 'bye' },
      },
    ],
  },
});

new Deployment(wordpress_chart, 'wordpress', {
  containers: [{ image: 'aymanzahran/wordpress:4.8-apache' }],
  replicas: 3,
});


new Deployment(mysql_chart, 'mysql', {
  containers: [{ image: 'aymanzahran/wordpress:4.8-apache' }],
  replicas: 3,
});

app.synth();
