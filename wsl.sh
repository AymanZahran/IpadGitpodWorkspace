# Install Utils
sudo apt install -y curl wget git unzip

# Update
sudo apt update -y && sudo apt upgrade -y

# Install npm, node, yarn, typecsript
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - && \
    sudo apt install -y nodejs && \
    sudo npm install -g npm && \
    sudo npm install -g yarn typescript

# Install python3, pip3, venv, pipenv
sudo apt install -y python3 python3-pip && \
    sudo pip3 install virtualenv pipenv

# Install .NET, NuGet
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo apt install -y apt-transport-https dotnet-sdk-3.1 nuget

# Install Java, Maven
sudo apt install -y maven

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    mkdir ~/.aws

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

## Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    sudo apt-get install terraform && \
    terraform -install-autocomplete

# Install AWS SAM
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip && \
    unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && \
    sudo ./sam-installation/install

# Install Serverless
sudo npm install -g serverless

# Install AWS CDK, CDKtf, CDK8s, Projen
sudo npm install -g aws-cdk cdktf-cli cdk8s-cli projen && \
    echo 'alias pj="npx projen"' >> /home/gitpod/.bashrc

# Install Terragrunt
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.3/terragrunt_linux_arm64 && \
    sudo mv terragrunt_linux_arm64 /usr/local/bin/terragrunt && \
    sudo chmod +x /usr/local/bin/terragrunt

# Install Runway
wget https://oni.ca/runway/latest/linux && \
    sudo mv linux /usr/local/bin/runway && \
    sudo chmod +x /usr/local/bin/runway

## Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl && \
    mkdir ~/.kube && \
    echo 'alias k="kubectl"' >> /home/gitpod/.bashrc

## Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && ./get_helm.sh

## Install Kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

## Install Krew & Krew Plugins
set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew && \
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && \
    echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /home/gitpod/.bashrc && \
    kubectl krew install neat access-matrix advise-psp cert-manager ca-cert get-all ingress-nginx ctx ns

# Update
sudo apt update -y && sudo apt upgrade -y && \
    sudo npm update -g && python3 -m pip install --upgrade pip
