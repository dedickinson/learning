FROM centos


RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo \
        && yum install -y powershell

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
        && sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo' \
        && yum install -y azure-cli

RUN pwsh -c "Install-Module AzureRM.NetCore -Force"
RUN pwsh -c "Install-Module azurepsdrive -Force"

RUN yum install -y bash-completion