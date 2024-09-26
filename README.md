# Docker-Compose-Gitea

A Docker Compose file for Gitea - Git with a cup of tea ([gitea.io](https://gitea.io)).

Data will be saved in separate Docker volumes to enable easy upgrades!

## Requirements

* Docker
* Docker Compose

## Getting Started

1. Copy **.env.dist** to **.env** and make your modifications. Below is an example `.env` file:
    ```bash
    POSTGRES_DB=gitea
    POSTGRES_USER=gitea
    POSTGRES_PASSWORD=gitea
    USER_UID=1000
    USER_GID=1000
    DB_TYPE=postgres
    DB_HOST=gitea-db:5432
    DB_NAME=gitea
    DB_USER=gitea
    DB_PASSWD=gitea
    ROOT_URL=http://localhost:3000/
    RUNNER_REGISTRATION_TOKEN_1=xyz123etc
    RUNNER_REGISTRATION_TOKEN_2=abc456etc
    ```

2. Start the Docker containers:
    ```bash
    docker-compose up -d
    ```

3. After starting the containers, open the Gitea installer in your browser: [http://localhost:3000](http://localhost:3000) and complete the setup form according to your `.env` settings.

    - Set **`gitea-db:5432`** in the _Database Host_ field and configure the rest using the PostgreSQL credentials defined in the `.env` file.

4. Once the setup is completed, register a new user using the link in the navigation bar.

    The first registered user will have admin privileges.

### Environment Configuration

| VARIABLE                   | Description                       | DEFAULT       |
|----------------------------|-----------------------------------|:-------------:|
| POSTGRES_DB           | PostgreSQL database name          |gitea          |
| POSTGRES_USER         | PostgreSQL database user          |gitea          |
| POSTGRES_PASSWORD     | PostgreSQL database password      |gitea          |
| USER_UID              | Gitea user UID                    |1000           |
| USER_GID              | Gitea user GID                    |1000           |
| DB_TYPE               | Database type                     |postgres       |
| DB_HOST               | Database host                     |gitea-db:5432  |
| DB_NAME               | Gitea database name               |gitea          |
| DB_USER               | Gitea database user               |gitea          |
| DB_PASSWD             | Gitea database password           |gitea          |
| ROOT_URL              | Gitea root URL                    |http://localhost:3000/ |
| RUNNER_REGISTRATION_TOKEN_1| Gitea runner 1 registration token |               |
| RUNNER_REGISTRATION_TOKEN_2| Gitea runner 2 registration token |               |

## Create systemd unit

1. Copy **docker-gitea.service.dist** to **docker-gitea.service**.
2. Adjust **WorkingDirectory** in the service file if needed.
3. Create a symbolic link: 
    ```bash
    ln -s docker-gitea.service /etc/systemd/system/docker-gitea.service
    ```
4. Start the service: 
    ```bash
    systemctl start docker-gitea
    ```
5. (Optional) Enable autostart at boot:
    ```bash
    systemctl enable docker-gitea
    ```

## Backing Up Gitea Data

This setup includes a script to backup Gitea data to an rsync.net account. This is separate from the database backup, which is handled by the cron-backups repository and scripts.

### Setup

1. Ensure you have an rsync.net account.

2. Add the following variables to your `.env` file:
   ```
   RSYNC_USERNAME=your_rsync_username
   RSYNC_SERVER=your_rsync_server
   SSH_KEY_PATH=/path/to/your/ssh/private/key
   ```

3. Make sure your SSH public key is added to your rsync.net account.

### Running the Backup

To run the backup manually:

1. Ensure you're in the same directory as the `gitea-data-sync.sh` script.
2. Run the script:
   ```bash
   ./gitea-data-sync.sh
   ```

This will sync the Gitea data volume to your rsync.net account.

### Automating Backups

To automate the backup process, you can set up a cron job:

1. Open your crontab file:
   ```bash
   crontab -e
   ```

2. Add a line to run the script daily at 2 AM (adjust the time as needed):
   ```
   0 2 * * * /path/to/your/gitea-data-sync.sh
   ```

Remember to replace `/path/to/your/gitea-data-sync.sh` with the actual path to the script.

### Restoring from Backup

To restore from the backup:

1. Stop the Gitea container:
   ```bash
   docker-compose stop gitea
   ```

2. Remove the existing Gitea data volume:
   ```bash
   docker volume rm docker-compose-gitea_gitea-data
   ```

3. Create a new empty volume:
   ```bash
   docker volume create docker-compose-gitea_gitea-data
   ```

4. Use rsync to copy the data from rsync.net to the new volume:
   ```bash
   rsync -avz -e ssh your_rsync_username@your_rsync_server:gitea/data/ /var/snap/docker/common/var-lib-docker/volumes/docker-compose-gitea_gitea-data/_data/
   ```

5. Start the Gitea container:
   ```bash
   docker-compose start gitea
   ```

Note: Adjust the paths as necessary for your specific setup.

This updated `README.md` now reflects the PostgreSQL setup, `.env` file usage, and the addition of backing up Gitea data using the `gitea-data-sync.sh` script.
