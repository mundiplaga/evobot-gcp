FROM --platform=amd64 debian:12-slim

# Version of Terraform desired
ARG TERRAFORM_VERSION="1.8.2"

# Install prereqs for terraform install
RUN apt update && apt install -y curl unzip

# Install Terraform
RUN curl -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm -f /tmp/terraform.zip

