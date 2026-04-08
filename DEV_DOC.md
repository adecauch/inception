# Developer Documentation

## Prerequisites

- Debian-based virtual machine
- Docker: `apt install docker.io`
- Docker Compose: `apt install docker-compose`
- Make: `apt install make`
- Add your user to the docker group: `/usr/sbin/usermod -aG docker <user>`

## Project structure

```
Inception/
├── Makefile
├── srcs/
│   ├── .env                  # Not committed — create locally
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
│       └── wordpress/
│           ├── Dockerfile
│           ├── conf/www.conf
│           └── tools/init.sh
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

**MariaDB:** On first start, `init.sh` runs `mysql_install_db`, starts a temporary mysqld instance, creates the database and users, then restarts mysqld as PID 1. On subsequent starts, the database directory already exists so initialization is skipped.

**WordPress:** On first start, `init.sh` waits for MariaDB to be ready, then uses WP-CLI to download WordPress, generate `wp-config.php`, install WordPress, and create a second user. On subsequent starts, `wp-config.php` already exists so initialization is skipped.

**NGINX:** On every start, `init.sh` generates a fresh self-signed TLS certificate using the `DOMAIN_NAME` variable, then starts nginx as PID 1.
