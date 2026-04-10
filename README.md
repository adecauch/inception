<!-- *********************************************************************** -->
<!--                                                                         -->
<!--                                                      :::      ::::::::  -->
<!-- README.md                                          :+:      :+:    :+:  -->
<!--                                                  +:+ +:+         +:+    -->
<!-- By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+       -->
<!--                                              +#+#+#+#+#+   +#+          -->
<!-- Created: 2026/04/10 10:38:58 by adecauch          #+#    #+#            -->
<!-- Updated: 2026/04/10 10:39:12 by adecauch         ###   ########.fr      -->
<!--                                                                         -->
<!-- *********************************************************************** -->

*This project has been created as part of the 42 curriculum by adecauch.*

## Description

Inception is a system administration project that uses Docker to set up a small infrastructure composed of multiple services. The goal is to virtualize a complete web stack inside a personal virtual machine using Docker Compose.

The infrastructure consists of three services running in dedicated containers:
- **NGINX** — the only entry point, serving HTTPS on port 443 with TLSv1.2/TLSv1.3
- **WordPress + PHP-FPM** — the web application, communicating with NGINX via FastCGI
- **MariaDB** — the database backend for WordPress

### Design choices

**Virtual Machines vs Docker**
A virtual machine emulates a full hardware environment with its own OS kernel. Docker containers share the host kernel and only isolate the user space, making them much lighter and faster to start. VMs offer stronger isolation; containers offer better resource efficiency and reproducibility.

**Secrets vs Environment Variables**
Environment variables are convenient but can be exposed via process listings or logs. Docker secrets store sensitive data in memory-only tmpfs mounts and are only accessible to authorized services. For this project, environment variables via a `.env` file are used (kept out of git), with secrets recommended for production.

**Docker Network vs Host Network**
Host network mode shares the host's network stack directly, bypassing container isolation. Docker bridge networks create an isolated virtual network where containers communicate by service name. Bridge networks are used here to enforce isolation and inter-container communication without exposing unnecessary ports.

**Docker Volumes vs Bind Mounts**
Bind mounts link a specific host path to a container path — simple but tied to the host's directory structure. Named volumes are managed by Docker and are more portable. This project uses named volumes with bind mount options to store data at `/home/adecauch/data` on the host, as required by the subject.

## Instructions

### Prerequisites
- A virtual machine running Debian
- Docker and Docker Compose installed
- `make` installed

### Configuration
Create the following files locally in the VM (never commit these):

`srcs/.env`:
```
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=<your_password>
MYSQL_ROOT_PASSWORD=<your_root_password>
DOMAIN_NAME=adecauch.42.fr
WP_ADMIN_USER=<admin_username>
WP_ADMIN_PASSWORD=<admin_password>
WP_ADMIN_EMAIL=<admin_email>
WP_USER=<user_username>
WP_USER_EMAIL=<user_email>
WP_USER_PASSWORD=<user_password>
```

Add the domain to `/etc/hosts`:
```
127.0.0.1 adecauch.42.fr
```

### Usage
```bash
make        # Build and start all services
make down   # Stop and remove containers
make stop   # Pause containers
make clean  # Remove containers, images, and data
make fclean # Full reset
make re     # fclean + all
```

The site is accessible at `https://adecauch.42.fr`.

## Resources

- [Docker documentation](https://docs.docker.com)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [WordPress documentation](https://developer.wordpress.org/)
- [WP-CLI documentation](https://wp-cli.org/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)
- [PID 1 and Docker best practices](https://cloud.google.com/architecture/best-practices-for-building-containers)
- [TLS best practices](https://wiki.mozilla.org/Security/Server_Side_TLS)
