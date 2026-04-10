<!-- *********************************************************************** -->
<!--                                                                         -->
<!--                                                      :::      ::::::::  -->
<!-- DEV_DOC.md                                         :+:      :+:    :+:  -->
<!--                                                  +:+ +:+         +:+    -->
<!-- By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+       -->
<!--                                              +#+#+#+#+#+   +#+          -->
<!-- Created: 2026/04/10 10:38:45 by adecauch          #+#    #+#            -->
<!-- Updated: 2026/04/10 11:38:05 by adecauch         ###   ########.fr      -->
<!--                                                                         -->
<!-- *********************************************************************** -->

# Developer Documentation

## Prerequisites

- Debian 12 (Bookworm) virtual machine
- Docker: `apt install docker.io`
- Docker Compose: `apt install docker-compose`
- Make: `apt install make`
- Add your user to the docker group: `/usr/sbin/usermod -aG docker <user>` (then log out and back in)

## Project structure

```
Inception/
├── Makefile
├── srcs/
│   ├── .env                          # Not committed — create locally
│   ├── docker-compose.yml
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── conf/50-server.cnf
│       │   └── tools/init.sh
│       ├── nginx/
│       │   ├── Dockerfile
│       │   ├── conf/nginx.conf
│       │   └── tools/init.sh
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   ├── conf/www.conf
│       │   └── tools/init.sh
│       └── bonus/
│           ├── redis/
│           │   ├── Dockerfile
│           │   └── conf/redis.conf
│           ├── ftp/
│           │   ├── Dockerfile
│           │   ├── conf/vsftpd.conf
│           │   └── tools/init.sh
│           ├── website/
│           │   ├── Dockerfile
│           │   └── conf/index.html
│           ├── adminer/
│           │   └── Dockerfile
│           └── portainer/
│               └── Dockerfile
```

## Environment setup

Clone the repository and create `srcs/.env`:

```bash
git clone <repo_url> Inception
cd Inception
vim srcs/.env
```

Required variables:

```
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=<password>
MYSQL_ROOT_PASSWORD=<root_password>
DOMAIN_NAME=adecauch.42.fr
WP_ADMIN_USER=<admin>        # Must not contain "admin" or "administrator"
WP_ADMIN_PASSWORD=<password>
WP_ADMIN_EMAIL=<email>
WP_USER=<username>
WP_USER_EMAIL=<email>
WP_USER_PASSWORD=<password>
FTP_USER=<ftp_username>
FTP_PASSWORD=<ftp_password>
```

Add the domain to `/etc/hosts`:

```bash
echo '127.0.0.1 adecauch.42.fr' >> /etc/hosts
```

## Build and launch

```bash
make        # Creates data directories, builds images, starts containers
make re     # Full rebuild from scratch
```

## Managing containers and volumes

```bash
docker ps                        # List running containers
docker logs <service>            # View logs
docker exec -it <service> bash   # Shell into a container

make down                        # Stop and remove containers
make clean                       # Remove containers + images + data
make fclean                      # Full reset including Docker cache
```

## Data persistence

WordPress and database data are stored on the host at:

```
/home/<user>/data/
├── db/          # MariaDB data (mounted at /var/lib/mysql in container)
└── wordpress/   # WordPress files (mounted at /var/www/html/wordpress)
```

These directories persist across `make down` but are deleted by `make clean` and `make fclean`.

## How initialization works

**MariaDB:** On first start, `init.sh` checks if the database directory exists. If not, it runs `mysql_install_db`, starts a temporary mysqld instance, creates the database and users, sets the root password, then kills the temporary instance and restarts mysqld as PID 1 via `exec`. On subsequent starts, initialization is skipped.

**WordPress:** On first start, `init.sh` waits for MariaDB to be ready, then uses WP-CLI to download WordPress core, generate `wp-config.php`, install WordPress, create a second user, and configure Redis. On subsequent starts, `wp-config.php` already exists so WordPress installation is skipped. Redis plugin setup runs on every start.

**NGINX:** On every start, `init.sh` generates a fresh self-signed TLS certificate using the `DOMAIN_NAME` variable, then starts nginx as PID 1 via `exec nginx -g "daemon off;"`.

**Redis:** Starts directly with `redis-server` pointing to its config. Configured with `bind 0.0.0.0`, `protected-mode no`, `maxmemory 256mb`, and `allkeys-lru` eviction policy.

**FTP (vsftpd):** `init.sh` creates the FTP user, sets its password, assigns ownership of the WordPress directory, then starts vsftpd as PID 1. Passive mode ports 21000–21010 are used for data transfers.

**Website:** NGINX serves a single static HTML page on port 80. No dynamic content.

**Adminer:** PHP built-in server serves `adminer.php` on port 8080. Connect to it using the MariaDB credentials from `.env`, with `mariadb` as the server hostname.

**Portainer:** The Portainer binary is downloaded from GitHub during the image build. It mounts the Docker socket (`/var/run/docker.sock`) to interact with the Docker daemon and display all running containers, volumes, and networks.
