import { App, Chart, ChartProps, ApiObject } from 'cdk8s';
// import { Deployment, Service } from 'cdk8s-plus-22';
import { Construct } from 'constructs';

export class MyChart extends Chart {
  constructor(scope: Construct, id: string, props: ChartProps = {}) {
    super(scope, id, props);
  }
}

const app = new App();

const GIT_REPO = 'https://github.com/AymanZahran/IpadGitpodWorkspace';

const kustomization_chart = new MyChart(app, 'kustomization');
const argo_chart = new MyChart(app, 'argo');
const tekton_chart = new MyChart(app, 'tekton');
const wordpress_chart = new MyChart(app, 'wordpress');
const mysql_chart = new MyChart(app, 'mysql');
const ingress_chart = new MyChart(app, 'ingress');

new ApiObject(kustomization_chart, 'kustomization', {
  apiVersion: 'kustomize.config.k8s.io/v1beta1',
  kind: 'Kustomization',
  metadata: {
    name: 'kustomization',
  },
  spec: {
    resources: [
      'namespace.yaml',
      'https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml',
      'https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml',
      'https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml',
      'https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml',
      'https://github.com/prometheus-operator/kube-prometheus/tree/main/manifests/setup',
      'https://github.com/prometheus-operator/kube-prometheus/tree/main/manifests',
      'https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/cloud/deploy.yaml',
    ],
  },
});

new ApiObject(argo_chart, 'Application', {
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

new ApiObject(tekton_chart, 'hi', {
  apiVersion: 'v1',
  kind: 'Task',
  metadata: {
    name: 'hi',
    namespace: 'tekton-pipelines',
  },
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

new ApiObject(wordpress_chart, 'wordpress-service', {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'wordpress',
    labels: {
      app: 'wordpress',
      tier: 'frontend',
    },
  },
  spec: {
    ports: [
      {
        port: 80,
        targetPort: 80,
      },
    ],
    selector: {
      app: 'wordpress',
      tier: 'frontend',
    },
  },
});

new ApiObject(mysql_chart, 'mysql-service', {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'mysql',
    labels: {
      app: 'wordpress',
      tier: 'mysql',
    },
  },
  spec: {
    ports: [
      {
        port: 80,
        targetPort: 80,
      },
    ],
    selector: {
      app: 'wordpress',
      tier: 'mysql',
    },
  },
});

new ApiObject(wordpress_chart, 'wordpress-deployment', {
  apiVersion: 'v1',
  kind: 'Deployment',
  metadata: {
    name: 'wordpress',
    labels: {
      app: 'wordpress',
      tier: 'frontend',
    },
  },
  spec: {
    selector: {
      matchLabels: {
        app: 'wordpress',
        tier: 'frontend',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'wordpress',
          tier: 'frontend',
        },
      },
      spec: {
        containers: [
          {
            image: 'wordpress:4.8-apache',
            name: 'wordpress',
            env: [
              {
                name: 'WORDPRESS_DB_HOST',
                value: 'mysql',
              },
              {
                name: 'WORDPRESS_DB_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mysql-pass',
                    key: 'password',
                  },
                },
              },
            ],
            ports: [
              {
                containerPort: 80,
                name: 'wordpress',
              },
            ],
            volumeMounts: [
              {
                name: 'wordpress-persistent-storage',
                mountPath: '/var/www/html',
              },
            ],
          },
        ],
        volumes: [
          {
            name: 'wordpress-persistent-storage',
            persistentVolumeClaim: {
              claimName: 'wp-pv-claim',
            },
          },
        ],
      },
    },
  },
});

new ApiObject(mysql_chart, 'mysql-deployment', {
  apiVersion: 'v1',
  kind: 'Deployment',
  metadata: {
    name: 'mysql',
    labels: {
      app: 'wordpress',
      tier: 'mysql',
    },
  },
  spec: {
    selector: {
      matchLabels: {
        app: 'wordpress',
        tier: 'mysql',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'wordpress',
          tier: 'mysql',
        },
      },
      spec: {
        containers: [
          {
            image: 'mysql:5.6',
            name: 'mysql',
            env: [
              {
                name: 'MYSQL_ROOT_PASSWORD',
                valueFrom: {
                  secretKeyRef: {
                    name: 'mysql-pass',
                    key: 'password',
                  },
                },
              },
            ],
            ports: [
              {
                containerPort: 3306,
                name: 'mysql',
              },
            ],
            volumeMounts: [
              {
                name: 'mysql-persistent-storage',
                mountPath: '/var/lib/mysql',
              },
            ],
          },
        ],
        volumes: [
          {
            name: 'mysql-persistent-storage',
            persistentVolumeClaim: {
              claimName: 'mysql-pv-claim',
            },
          },
        ],
      },
    },
  },
});

new ApiObject(ingress_chart, 'ingress-jenkins', {
  apiVersion: 'v1',
  kind: 'ingress',
  metadata: {
    name: 'jenkins',
    namespace: 'default',
  },
  spec: {
    ingressClassName: 'nginx',
    rules: [
      {
        http: {
          paths: [
            {
              path: '/jenkins',
              pathType: 'Prefix',
              backend: {
                serviceName: 'jenkins',
                servicePort: 80,
              },
            },
          ],
        },
      },
    ],
  },
});

new ApiObject(ingress_chart, 'ingress-prometheus', {
  apiVersion: 'v1',
  kind: 'ingress',
  metadata: {
    name: 'kube-prometheus-stack',
    namespace: 'kube-prometheus-stack',
  },
  spec: {
    ingressClassName: 'nginx',
    rules: [
      {
        http: {
          paths: [
            {
              path: '/prometheus',
              pathType: 'Prefix',
              backend: {
                serviceName: 'kube-prometheus-stack-prometheus',
                servicePort: 9090,
              },
            },
          ],
        },
      },
      {
        http: {
          paths: [
            {
              path: '/grafana',
              pathType: 'Prefix',
              backend: {
                serviceName: 'kube-prometheus-stack-grafana',
                servicePort: 80,
              },
            },
          ],
        },
      },
    ],
  },
});

new ApiObject(ingress_chart, 'ingress-kubernetes-dashboard', {
  apiVersion: 'v1',
  kind: 'ingress',
  metadata: {
    name: 'kubernetes-dashboard',
    namespace: 'kubernetes-dashboard',
  },
  spec: {
    ingressClassName: 'nginx',
    rules: [
      {
        http: {
          paths: [
            {
              path: '/dashboard',
              pathType: 'Prefix',
              backend: {
                serviceName: 'kubernetes-dashboard',
                servicePort: 443,
              },
            },
          ],
        },
      },
    ],
  },
});

new ApiObject(ingress_chart, 'ingress-tekton-dashboard', {
  apiVersion: 'v1',
  kind: 'ingress',
  metadata: {
    name: 'tekton-dashboard',
    namespace: 'tekton-pipelines',
    annotations: {
      'kubernetes.io/ingress.class': 'nginx',
      'nginx.ingress.kubernetes.io/rewrite-target': '/$2',
    },
  },
  spec: {
    rules: [
      {
        http: {
          paths: [
            {
              path: ' /tekton(/|$)(.*)',
              pathType: 'Prefix',
              backend: {
                serviceName: 'tekton-dashboard',
                servicePort: 9097,
              },
            },
          ],
        },
      },
    ],
  },
});

app.synth();
