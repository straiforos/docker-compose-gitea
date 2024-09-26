#!/bin/bash

# Install necessary packages
apt-get update && apt-get install -y cron rsync openssh-client

# Make the gitea-data-sync.sh script executable
chmod +x /gitea-data-sync.sh

# Create an environment file for cron
env | grep -E '^(RSYNC_USERNAME|RSYNC_SERVER|SSH_KEY_PATH|BACKUP_CRON_SCHEDULE)' > /etc/environment

# Start the SSH agent and add the SSH key
eval $(ssh-agent -s)
ssh-add $SSH_KEY_PATH

# Add rsync.net host key to known_hosts
ssh-keyscan -H $RSYNC_SERVER >> /root/.ssh/known_hosts

# Create a wrapper script to source environment variables and run the backup script
cat << EOF > /run-backup.sh
#!/bin/bash
# Source the environment file
. /etc/environment

# Run the backup script
/bin/bash /gitea-data-sync.sh >> /var/log/gitea-backup.log 2>&1
EOF

chmod +x /run-backup.sh

# Set up the cron job to use the wrapper script
echo "$BACKUP_CRON_SCHEDULE /run-backup.sh" > /etc/cron.d/backup-cron

# Make sure the log file exists and has proper permissions
touch /var/log/gitea-backup.log
chmod 644 /var/log/gitea-backup.log

# Load the cron job
crontab /etc/cron.d/backup-cron

# Start cron in the foreground
cron -f
