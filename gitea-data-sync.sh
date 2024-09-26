#!/bin/bash

# Declare variables
VOLUME_NAME="docker-compose-gitea_gitea-data"
DOCKER_VOLUMES_PATH="/backup/gitea-data"
DEST_PATH="gitea/data"
SOURCE_PATH="${DOCKER_VOLUMES_PATH}/"

# Check if required environment variables are set
if [ -z "$RSYNC_USERNAME" ] || [ -z "$RSYNC_SERVER" ] || [ -z "$SSH_KEY_PATH" ]; then
    echo "Error: RSYNC_USERNAME, RSYNC_SERVER, or SSH_KEY_PATH environment variables are not set"
    exit 1
fi

# Check if the source directory exists
if [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Could not find the data directory for volume $VOLUME_NAME"
    exit 1
fi

# Check if the SSH key file exists
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Error: SSH key file not found at $SSH_KEY_PATH"
    exit 1
fi

# Rsync command with variables
rsync -avz -e "ssh -i $SSH_KEY_PATH -o StrictHostKeyChecking=no" \
--partial --info=progress2 --no-o --no-g --delete \
"$SOURCE_PATH" "${RSYNC_USERNAME}@${RSYNC_SERVER}:${DEST_PATH}"

echo "Backup completed successfully"
