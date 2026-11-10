*This project has been created as part of the 42 curriculum by smikhail*

## Description

Inception is a system administration project that uses Docker to set up a small infrastructure of services:

- **NGINX**: HTTPS reverse proxy with TLS 1.2/1.3, only entry point (port 443)
- **WordPress + PHP-FPM**: WordPress CMS with FastCGI process manager
- **MariaDB**: MySQL-compatible relational database

## Instructions

### Prerequisites

- Docker Engine and Docker Compose Plugin installed
- GNU Make

### Setup & Run

```bash
# 1. Add domain to /etc/hosts (once)
echo "127.0.0.1 smikhail.42.fr" | sudo tee -a /etc/hosts

# 2. Build and start all containers
make

# 3. Open in browser
# https://smikhail.42.fr
```

### Makefile Commands

| Command | Description |
|---------|-------------|
| `make` | Create data dirs + build + start |
| `make down` | Stop containers |
| `make clean` | Remove containers and Docker volumes |
| `make fclean` | Full cleanup including host data |
| `make re` | Full rebuild from scratch |

## Resources

### AI Usage

AI assistance was used to:
- Understand Docker networking and volume concepts
- Debug shell script initialization sequences
- Review Dockerfile and configuration files for compliance with subject rules

All code was written, understood, and validated by smikhail.
