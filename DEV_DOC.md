# Developer Documentation — Inception

## Prerequisites

- Docker Engine 20.10+
- Docker Compose Plugin v2+
- GNU Make

## Project Structure

```
INCEPTION/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env                        <- credentials (not in git)
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/nginx.conf
        │   └── tools/setup.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/www.conf
        │   └── tools/wp_setup.sh
        └── mariadb/
            ├── Dockerfile
            ├── conf/mariadb.conf
            └── tools/mariadb_setup.sh
```

## Setup

```bash
# Add domain to /etc/hosts
echo "127.0.0.1 smikhail.42.fr" | sudo tee -a /etc/hosts

# Run the stack
make
```

## Makefile Reference

| Command | What it does |
|---------|--------------|
| `make` | setup + build + start |
| `make up` | build + start containers |
| `make down` | stop containers |
| `make clean` | stop + remove containers + Docker volumes |
| `make fclean` | everything above + delete host data dirs |
| `make re` | fclean + all (full rebuild) |

## Docker Compose

```bash
# Status
docker compose -f srcs/docker-compose.yml ps

# Follow logs
docker compose -f srcs/docker-compose.yml logs -f

# Rebuild one service
docker compose -f srcs/docker-compose.yml up -d --build nginx

# Shell into a container
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash
```

## Data Persistence

Data is stored on the host (persists across reboots):

| Service | Host path | Container path |
|---------|-----------|----------------|
| WordPress | `/home/smikhail/data/wordpress` | `/var/www/html` |
| MariaDB | `/home/smikhail/data/mariadb` | `/var/lib/mysql` |

## Logging into MariaDB

```bash
# Log in with the WordPress database user (reads DB_PASSWORD from .env)
docker exec -it mariadb mariadb -u wp_user -p wordpress

# Check that the database is not empty as root (reads DB_ROOT_PASSWORD from .env)
docker exec -it mariadb mariadb -u root -p -e "SHOW DATABASES; USE wordpress; SHOW TABLES;"
```

## TLS Certificate

Auto-generated at startup by `setup.sh` (OpenSSL, self-signed, 365 days):

- `/etc/ssl/certs/inception.crt`
- `/etc/ssl/private/inception.key`

Protocols: TLS 1.2 and TLS 1.3 only.

## Architecture

```
Internet (port 443)
       |
  [nginx:443]  <-- only exposed port, handles TLS
       | FastCGI (port 9000)
  [wordpress]  <-- PHP-FPM processes WordPress PHP
       | MySQL (port 3306)
  [mariadb]    <-- stores all WordPress data

All on Docker network: inception (bridge)
```
