FROM mcr.microsoft.com/dotnet/sdk:8.0

# Instala herramientas necesarias incluyendo zip y Azure CLI
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    apt-transport-https \
    lsb-release \
    gnupg \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN useradd -m azurepipelines
USER azurepipelines
# Crear carpeta para el agente
WORKDIR /home/azurepipelines

# Descargar el agente de Azure DevOps (versiÃ³n 3.236.1)
ENV AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/3.236.1/vsts-agent-linux-x64-3.236.1.tar.gz

RUN curl -Ls $AZP_AGENTPACKAGE_URL | tar -xz && \
    chmod +x ./bin/Agent.Listener

USER root
# Copiar el script de arranque
COPY start.sh .
RUN chmod +x start.sh

USER azurepipelines

ENTRYPOINT ["./start.sh"]