# User Documentation — Inception

## Starting the Stack

```bash
make
```

This command creates data directories, builds all Docker images, and starts all containers.

## Stopping the Stack

```bash
make down
```

## Accessing the Website

Open: **https://smikhail.42.fr**

> A self-signed certificate warning will appear in the browser. Click "Advanced" -> "Proceed anyway".

## WordPress Admin Panel

URL: **https://smikhail.42.fr/wp-admin**

- Username: configured in `srcs/.env` as `WP_ADMIN_USER` (e.g. `smikhail_boss`)
- Password: configured in `srcs/.env` as `WP_ADMIN_PASSWORD`

## WordPress Normal User (for comments)

URL: **https://smikhail.42.fr**

- Username: configured in `srcs/.env` as `WP_USER` (e.g. `smikhail_user`)
- Password: configured in `srcs/.env` as `WP_USER_PASSWORD`

## Managing Credentials

All credentials are in `srcs/.env`. This file is **not committed to git**.

## Health Checks

```bash
# Check running containers
docker compose -f srcs/docker-compose.yml ps

# Check networks
docker network ls

# Check volumes
docker volume ls

# View logs
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```
