FROM ubuntu:focal

ARG USERNAME="clouduser"
ENV HOME=/home/$USERNAME
ARG DEBIAN_FRONTEND=noninteractive

# Install Utils
RUN yes | unminimize && apt install -y ca-certificates curl netbase wget tzdata gnupg dirmngr bzr git mercurial openssh-client subversion \
        procps autoconf automake bzip2 dpkg-dev file g++ gcc imagemagick libbz2-dev libc6-dev libcurl4-openssl-dev libdb-dev \
        libevent-dev libffi-dev libgdbm-dev libglib2.0-dev libgmp-dev libjpeg-dev libkrb5-dev liblzma-dev libmagickcore-dev \
        libmagickwand-dev libmaxminddb-dev libncurses5-dev libncursesw5-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev \
        libssl-dev libtool libwebp-dev libxml2-dev libxslt-dev libyaml-dev make patch zip unzip xz-utils zlib1g-dev \
        git-lfs bash-completion build-essential ninja-build htop jq less locales man-db nano ripgrep software-properties-common \
        sudo time emacs-nox vim multitail lsof ssl-cert fish zsh

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# Add User
RUN useradd -l -u 10101 -G sudo -md /home/$USERNAME -s /bin/bash -p $USERNAME $USERNAME \
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

WORKDIR $HOME
RUN { echo && echo "PS1='\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 \" (%s)\") $ '" ; } >> .bashrc

USER $USERNAME
RUN sudo echo "Running 'sudo' for $USERNAME: success" && \
    mkdir -p $HOME/.bashrc.d && \
    (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> $HOME/.bashrc

# Update
RUN sudo apt update -y && sudo apt upgrade -y

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
    sudo apt install -y apt-transport-https && \
    sudo apt update -y && sudo apt install -y dotnet-sdk-6.0 nuget

# Install troposphere, cfn-lint
RUN pip3 install troposphere cfn-lint

# Install AWS CLI, SAM
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && unzip awscliv2.zip && sudo ./aws/install && \
    wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip && unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && sudo ./sam-installation/install


# Install AWS CDK, CDKtf, CDK8s, Projen, Serverless Framework
RUN sudo npm install -g aws-cdk cdktf-cli cdk8s-cli projen serverless

# Install Terragrunt, ECS CLI, Runway, AWSTOE, cloud-nuke, docker, kubectl, Pulumi, Amplify, Helm, Kustomize, Azure CLI, Terraform, Packer, Vagrant
RUN sudo curl -Lo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.6/terragrunt_linux_amd64 && \
    sudo curl -Lo /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest && \
    sudo curl -Lo /usr/local/bin/runway https://oni.ca/runway/latest/linux && \
    sudo curl -Lo /usr/local/bin/awstoe https://awstoe-us-east-1.s3.us-east-1.amazonaws.com/latest/linux/amd64/awstoe && \
    sudo curl -Lo /usr/local/bin/cloud-nuke https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.11.3/cloud-nuke_linux_amd64 && \
    curl -fsSL https://get.docker.com | sudo bash && \
    sudo curl -Lo /usr/local/bin/kubectl https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
    curl -fsSL https://get.pulumi.com | sudo bash && \
    curl -sL https://aws-amplify.github.io/amplify-cli/install | sudo bash && $SHELL && \
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash && \
    curl -s https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | sudo bash && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    sudo apt-get install terraform packer vagrant && terraform -install-autocomplete && \
    sudo chmod +x /usr/local/bin/*

## Install Krew & Krew Plugins
RUN set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew && \
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && \
    echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> $HOME/.bashrc && \
    kubectl krew install neat access-matrix advise-psp cert-manager ca-cert get-all ingress-nginx ctx ns

# Configs
RUN mkdir $HOME/.aws && \
    echo 'alias pj="npx projen"' >> $HOME/.bashrc && \
    mkdir $HOME/.kube && echo 'alias k="kubectl"' >> $HOME/.bashrc

# Update
RUN sudo apt update -y && sudo apt upgrade -y && \
    sudo npm update -g && python3 -m pip install --upgrade pip
