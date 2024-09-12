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

| VARIABLE              | Description                       | DEFAULT       |
| ----------------------|-----------------------------------|:-------------:|               
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

This updated `README.md` now reflects the PostgreSQL setup and the `.env` file usage. Let me know if you'd like further modifications!
