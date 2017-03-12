FROM centos:7 
MAINTAINER Karl Stoney <me@karlstoney.com>

# Component versions used in this build
ENV KUBECTL_VERSION 1.5.3
ENV TERRAFORM_VERSION 0.8.7
ENV PEOPLEDATA_CLI_VERSION 1.2.36
ENV CLOUD_SDK_VERSION 146.0.0

# Get nodejs repos
RUN curl --silent --location https://rpm.nodesource.com/setup_7.x | bash - 

# Setup gcloud repos
ENV CLOUDSDK_INSTALL_DIR /usr/lib64/google-cloud-sdk
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
COPY gcloud.repo /etc/yum.repos.d/
RUN mkdir -p /etc/gcloud/keys

# Install packages 
RUN yum -y -q update && \
    yum -y -q install google-cloud-sdk-$CLOUD_SDK_VERSION nodejs wget curl \
              python-openssl build-essential libssl-dev g++ unzip git-core which && \
    yum -y -q clean all

# Disable google cloud auto update... we should be pushing a new agent container
RUN gcloud config set --installation component_manager/disable_update_check true
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' $CLOUDSDK_INSTALL_DIR/lib/googlecloudsdk/core/config.json

# Terraform
RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION\_linux_amd64.zip && \
    unzip terraform_*.zip && \
    mv terraform /usr/local/bin && \
    rm -rf *terraform*

# Get the target version of KubeCTL 
RUN cd /usr/local/bin && \
    wget --quiet https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x kubectl

# Add the Peopledata CLI
ARG GO_DEPENDENCY_LABEL_CLI_PEOPLEDATA=
RUN npm install -g --depth=0 --no-summary --quiet peopledata-cli@$PEOPLEDATA_CLI_VERSION && \
    rm -rf /tmp/npm*

RUN mkdir -p /app
WORKDIR /app

# Boot commands
COPY / /app/
ENTRYPOINT ["/app/start"]
