<!-- *********************************************************************** -->
<!--                                                                         -->
<!--                                                      :::      ::::::::  -->
<!-- USER_DOC.md                                        :+:      :+:    :+:  -->
<!--                                                  +:+ +:+         +:+    -->
<!-- By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+       -->
<!--                                              +#+#+#+#+#+   +#+          -->
<!-- Created: 2026/04/10 10:39:04 by adecauch          #+#    #+#            -->
<!-- Updated: 2026/04/10 11:38:14 by adecauch         ###   ########.fr      -->
<!--                                                                         -->
<!-- *********************************************************************** -->

# User Documentation

## Services

This stack provides a complete WordPress website over HTTPS, backed by MariaDB, with Redis caching, FTP access, a static site, a database management interface, and a Docker dashboard.

| Service | Role | Access |
|---------|------|--------|
| NGINX | Web server / entry point | `https://adecauch.42.fr` |
| WordPress | Web application | `https://adecauch.42.fr` |
| MariaDB | Database | Internal only |
| Redis | Object cache | Internal only |
| vsftpd | FTP server | `ftp://adecauch.42.fr` |
| Website | Static site | `http://adecauch.42.fr` |
| Adminer | Database interface | `http://adecauch.42.fr:8080/adminer.php` |
| Portainer | Docker dashboard | `http://adecauch.42.fr:9000` |

## Starting and stopping the project

From the root of the repository:

```bash
make          # Start all services (builds images if needed)
make stop     # Pause all services without removing them
make down     # Stop and remove containers (data is preserved)
make fclean   # Full reset — removes containers, images, and all data
```

## Accessing the services

**WordPress site:**
```
https://adecauch.42.fr
```
Your browser will show a security warning because the SSL certificate is self-signed. Accept the exception to proceed.

**WordPress admin panel:**
```
https://adecauch.42.fr/wp-admin
```
Log in with the `WP_ADMIN_USER` and `WP_ADMIN_PASSWORD` credentials from `srcs/.env`.

**Static website:**
```
http://adecauch.42.fr
```

**Adminer (database management):**
```
http://adecauch.42.fr:8080/adminer.php
```
- System: MySQL
- Server: `mariadb`
- Username: value of `MYSQL_USER`
- Password: value of `MYSQL_PASSWORD`
- Database: value of `MYSQL_DATABASE`

**Portainer (Docker dashboard):**
```
http://adecauch.42.fr:9000
```
Create an admin account on first visit. You can then view all running containers, logs, volumes, and networks.

**FTP (WordPress files):**
```
ftp://adecauch.42.fr
```
Log in with `FTP_USER` and `FTP_PASSWORD` from `srcs/.env`. The FTP root is the WordPress directory.

## Credentials

All credentials are stored in `srcs/.env` on the VM (never committed to git):

| Variable | Purpose |
|----------|---------|
| `MYSQL_USER` / `MYSQL_PASSWORD` | WordPress database user |
| `MYSQL_ROOT_PASSWORD` | MariaDB root password |
| `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD` | WordPress administrator |
| `WP_USER` / `WP_USER_PASSWORD` | WordPress regular user |
| `FTP_USER` / `FTP_PASSWORD` | FTP login |

## Checking that services are running

```bash
docker ps
```

All containers should show `Up` status: `mariadb`, `wordpress`, `nginx`, `redis`, `ftp`, `website`, `adminer`, `portainer`.

To view logs for a specific service:

```bash
docker logs mariadb
docker logs wordpress
docker logs nginx
docker logs redis
docker logs ftp
docker logs website
docker logs adminer
docker logs portainer
```
