FROM gitpod/workspace-base

# Update
RUN sudo apt update -y && sudo apt upgrade -y

# Install Basic Packages
RUN sudo apt install -y ca-certificates curl netbase wget tzdata gnupg dirmngr bzr git mercurial openssh-client subversion \
        procps autoconf automake bzip2 dpkg-dev file g++ gcc imagemagick libbz2-dev libc6-dev libcurl4-openssl-dev libdb-dev \
        libevent-dev libffi-dev libgdbm-dev libglib2.0-dev libgmp-dev libjpeg-dev libkrb5-dev liblzma-dev libmagickcore-dev \
        libmagickwand-dev libmaxminddb-dev libncurses5-dev libncursesw5-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev \
        libssl-dev libtool libwebp-dev libxml2-dev libxslt-dev libyaml-dev make patch zip unzip xz-utils zlib1g-dev \
        git-lfs bash-completion build-essential ninja-build htop jq less locales man-db nano ripgrep software-properties-common \
        sudo time emacs-nox vim multitail lsof ssl-cert fish zsh iputils-ping apt-transport-https ca-certificates gnupg lsb-release telnet

# Install npm, node, yarn, typecsript, python3, pip3, venv, pipenv, Java, Maven, .NET, NuGet
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - && \
    sudo apt install -y nodejs && \
    sudo npm install -g npm && \
    sudo npm install -g yarn typescript && \
    sudo apt install -y python3 python3-pip && \
    sudo pip3 install virtualenv pipenv && \
    sudo apt install -y maven && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo apt update -y && sudo apt install -y dotnet-sdk-6.0 nuget

# Install AWS CLI, SAM
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && unzip awscliv2.zip && sudo ./aws/install && \
    wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip && unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && sudo ./sam-installation/install

# Install AWS CDK, CDKtf, CDK8s, Projen, Serverless Framework, troposphere, cfn-lint
RUN sudo npm install -g aws-cdk cdktf-cli cdk8s-cli projen serverless && \
    sudo pip3 install troposphere cfn-lint

# Install Terragrunt, ECS CLI, Runway, AWSTOE, cloud-nuke, doctl, aws-nuke, EKSCTL, Minikube, Pulumi, Amplify, Helm
# Kustomize CLI, Terraform, Packer, Vagrant, Azure CLI, Flux, Okteto, Linode, Tekton, argocd, argocd-autopilot
RUN sudo curl -Lo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.6/terragrunt_linux_amd64 && \
    sudo curl -Lo /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest && \
    sudo curl -Lo /usr/local/bin/runway https://oni.ca/runway/latest/linux && \
    sudo curl -Lo /usr/local/bin/awstoe https://awstoe-us-east-1.s3.us-east-1.amazonaws.com/latest/linux/amd64/awstoe && \
    sudo curl -Lo /usr/local/bin/cloud-nuke https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.11.3/cloud-nuke_linux_amd64 && \
    wget -c https://github.com/digitalocean/doctl/releases/download/v1.81.0/doctl-1.81.0-linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local/bin/ && \
    wget -c https://github.com/rebuy-de/aws-nuke/releases/download/v2.16.0/aws-nuke-v2.16.0-linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local/bin/ && \
    wget -c https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz -O - | sudo tar -xz -C /usr/local/bin/ && \
    sudo curl -Lo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
    curl -fsSL https://get.pulumi.com | sudo bash && \
    curl -sL https://aws-amplify.github.io/amplify-cli/install | sudo bash && $SHELL && \
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash && \
    curl -s https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | sudo bash && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    sudo apt-get install terraform packer vagrant && terraform -install-autocomplete && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && \
    curl -s https://fluxcd.io/install.sh | sudo bash  && \
    curl https://get.okteto.com -sSfL | bash && \
    pip3 install linode-cli --upgrade && \
    curl -LO https://github.com/tektoncd/cli/releases/download/v0.26.0/tkn_0.26.0_Linux_x86_64.tar.gz && \
    sudo tar xvzf tkn_0.26.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn && \
    VERSION=$(curl --silent "https://api.github.com/repos/argoproj-labs/argocd-autopilot/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/') && \
    sudo curl -L --output - https://github.com/argoproj-labs/argocd-autopilot/releases/download/$VERSION/argocd-autopilot-linux-amd64.tar.gz | tar zx && \
    sudo mv ./argocd-autopilot-* /usr/local/bin/argocd-autopilot && \
    VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/') && \
    sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-amd64 && \
    sudo chmod +x /usr/local/bin/*

# Instal GCP CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    sudo curl -fsSLo /usr/share/keyrings/cloud.google.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    sudo apt update -y && \
    sudo apt install -y google-cloud-cli google-cloud-cli-anthos-auth google-cloud-cli-app-engine-go google-cloud-cli-app-engine-grpc google-cloud-cli-app-engine-java \
        google-cloud-cli-app-engine-python google-cloud-cli-app-engine-python-extras google-cloud-cli-bigtable-emulator google-cloud-cli-cbt \
        google-cloud-cli-cloud-build-local google-cloud-cli-cloud-run-proxy google-cloud-cli-config-connector google-cloud-cli-datalab google-cloud-cli-datastore-emulator \
        google-cloud-cli-firestore-emulator google-cloud-cli-gke-gcloud-auth-plugin google-cloud-cli-kpt google-cloud-cli-kubectl-oidc google-cloud-cli-local-extract \
        google-cloud-cli-minikube google-cloud-cli-nomos google-cloud-cli-pubsub-emulator google-cloud-cli-skaffold google-cloud-cli-spanner-emulator \
        google-cloud-cli-terraform-validator google-cloud-cli-tests

# Install docker, kubeadm, kubelet, kubectl, kind
RUN curl -fsSL https://get.docker.com | sudo bash && \
    echo "br_netfilter" | sudo tee /etc/modules-load.d/k8s.conf && \
    echo "net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee /etc/sysctl.d/k8s.conf && \
    echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee /etc/sysctl.d/k8s.conf && \
    sudo sysctl --system && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    sudo apt update -y && \
    sudo apt install -y kubectl && \
    sudo curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64 && \
    sudo chmod +x /usr/local/bin/kind

## Install Krew & Krew Plugins (neat, access-matrix, advise-psp, cert-manager, ca-cert, get-all, ingress-nginx, ctx, ns)
RUN set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew && \
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && \
    echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> $HOME/.bashrc && \
    kubectl krew install neat access-matrix advise-psp cert-manager ca-cert get-all ingress-nginx ctx ns kubesec-scan

# Configs
RUN mkdir $HOME/.aws && \
    echo 'alias pj="npx projen"' >> $HOME/.bashrc && \
    mkdir $HOME/.kube && \
    echo 'alias k="kubectl"' >> $HOME/.bashrc && \
    echo 'alias aws-nuke=aws-nuke-v2.16.0-linux-amd64' >> $HOME/.bashrc 

# Update
RUN sudo apt update -y && sudo apt upgrade -y && \
    sudo npm update -g && python3 -m pip install --upgrade pip
