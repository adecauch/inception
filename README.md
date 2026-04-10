<!-- *********************************************************************** -->
<!--                                                                         -->
<!--                                                      :::      ::::::::  -->
<!-- README.md                                          :+:      :+:    :+:  -->
<!--                                                  +:+ +:+         +:+    -->
<!-- By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+       -->
<!--                                              +#+#+#+#+#+   +#+          -->
<!-- Created: 2026/04/10 10:38:58 by adecauch          #+#    #+#            -->
<!-- Updated: 2026/04/10 11:38:10 by adecauch         ###   ########.fr      -->
<!--                                                                         -->
<!-- *********************************************************************** -->

*This project has been created as part of the 42 curriculum by adecauch.*

## Description

Inception is a system administration project that uses Docker to set up a small infrastructure composed of multiple services. The goal is to virtualize a complete web stack inside a personal virtual machine using Docker Compose, with each service running in its own dedicated container built from a custom Dockerfile.

### Services

**Mandatory:**
| Service | Role | Port |
|---------|------|------|
| NGINX | Entry point, TLS termination | 443 (HTTPS) |
| WordPress + PHP-FPM | Web application | 9000 (internal) |
| MariaDB | Database | 3306 (internal) |

**Bonus:**
| Service | Role | Port |
|---------|------|------|
| Redis | WordPress object cache | 6379 (internal) |
| vsftpd | FTP access to WordPress files | 21, 21000–21010 |
| Website | Static site (HTML/CSS) | 80 |
| Adminer | MariaDB web interface | 8080 |
| Portainer | Docker management dashboard | 9000 |

### Design choices

**Virtual Machines vs Docker**
A virtual machine emulates a full hardware environment with its own OS kernel, offering strong isolation at the cost of significant resource overhead. Docker containers share the host kernel and only isolate the user space, making them much lighter, faster to start, and more reproducible. This project runs inside a VM (for isolation from the host) but uses Docker inside it to manage each service independently.

**Secrets vs Environment Variables**
Environment variables are convenient but can be exposed via process listings, logs, or child processes. Docker secrets store sensitive data in memory-only tmpfs mounts, only accessible to the services explicitly granted access. For this project, environment variables via a `.env` file are used and kept out of git. In a production environment, Docker secrets would be preferred for credentials.

**Docker Network vs Host Network**
Host network mode shares the host's network stack directly, exposing all container ports on the host and bypassing container isolation. Docker bridge networks create an isolated virtual network where containers communicate by service name without exposing unnecessary ports. A custom bridge network (`inception`) is used here so containers can reach each other by name while only the explicitly declared ports are accessible from outside.

**Docker Volumes vs Bind Mounts**
Bind mounts link a specific host directory path into a container — simple but tightly coupled to the host's filesystem layout. Named volumes are managed by Docker and more portable across environments. This project uses named volumes configured with local driver bind options to satisfy both requirements: Docker-managed named volumes that store their data at `/home/adecauch/data` on the host as required by the subject.

## Instructions

### Prerequisites
- A virtual machine running Debian 12 (Bookworm)
- Docker and Docker Compose installed
- `make` installed

### Configuration

Create `srcs/.env` on the VM (never commit this file):

```
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=<your_password>
MYSQL_ROOT_PASSWORD=<your_root_password>
DOMAIN_NAME=adecauch.42.fr
WP_ADMIN_USER=<admin_username>     # Must not contain "admin" or "administrator"
WP_ADMIN_PASSWORD=<admin_password>
WP_ADMIN_EMAIL=<admin_email>
WP_USER=<user_username>
WP_USER_EMAIL=<user_email>
WP_USER_PASSWORD=<user_password>
FTP_USER=<ftp_username>
FTP_PASSWORD=<ftp_password>
PORTAINER_PASSWORD=<portainer_password>
```

Add the domain to `/etc/hosts` on both the VM and the host machine:
```
127.0.0.1 adecauch.42.fr
```

### Usage

```bash
make        # Build and start all services
make down   # Stop and remove containers (data preserved)
make stop   # Pause containers
make clean  # Remove containers, images, and data
make fclean # Full reset including Docker cache
make re     # fclean + all
```

| URL | Service |
|-----|---------|
| `https://adecauch.42.fr` | WordPress |
| `https://adecauch.42.fr/wp-admin` | WordPress admin panel |
| `http://adecauch.42.fr` | Static website |
| `http://adecauch.42.fr:8080/adminer.php` | Adminer (MariaDB) |
| `http://adecauch.42.fr:9000` | Portainer (Docker dashboard) |
| `ftp://adecauch.42.fr` | FTP (WordPress files) |

## Resources

- [Docker documentation](https://docs.docker.com)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [WordPress documentation](https://developer.wordpress.org/)
- [WP-CLI documentation](https://wp-cli.org/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)
- [vsftpd documentation](https://security.appspot.com/vsftpd.html)
- [Redis documentation](https://redis.io/docs/)
- [Portainer documentation](https://docs.portainer.io/)
- [PID 1 and Docker best practices](https://cloud.google.com/architecture/best-practices-for-building-containers)
- [TLS best practices](https://wiki.mozilla.org/Security/Server_Side_TLS)
