#!/bin/bash
set -e

if [ -z "$AZP_URL" ] || [ -z "$AZP_TOKEN" ] || [ -z "$AZP_POOL" ] || [ -z "$AZP_AGENT_NAME" ]; then
  echo "Missing required environment variables: AZP_URL, AZP_TOKEN, AZP_POOL, AZP_AGENT_NAME"
  exit 1
fi

if [ ! -f ".agent" ]; then
  echo "Configuring the Azure DevOps agent..."
  ./config.sh --unattended \
    --url "$AZP_URL" \
    --auth pat \
    --token "$AZP_TOKEN" \
    --pool "$AZP_POOL" \
    --agent "$AZP_AGENT_NAME" \
    --acceptTeeEula \
    --replace
else
  echo "Agent already configured. Skipping configuration."
fi

trap 'echo "Shutting down agent..."; exit 0' SIGINT SIGTERM

# Run agent in foreground (blocks and keeps container running)
./run.sh
