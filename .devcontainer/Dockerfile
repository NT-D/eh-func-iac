FROM mcr.microsoft.com/azure-functions/dotnet:3.0-dotnet3-core-tools

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Terraform CLI
## Ready for using apt-add-repository
RUN sudo apt-get install --assume-yes software-properties-common
RUN sudo apt-get update

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN sudo apt-get update && sudo apt-get install terraform