<!-- *********************************************************************** -->
<!--                                                                         -->
<!--                                                      :::      ::::::::  -->
<!-- USER_DOC.md                                        :+:      :+:    :+:  -->
<!--                                                  +:+ +:+         +:+    -->
<!-- By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+       -->
<!--                                              +#+#+#+#+#+   +#+          -->
<!-- Created: 2026/04/10 10:39:04 by adecauch          #+#    #+#            -->
<!-- Updated: 2026/04/10 10:39:12 by adecauch         ###   ########.fr      -->
<!--                                                                         -->
<!-- *********************************************************************** -->

# User Documentation

## Services

This stack provides a WordPress website accessible over HTTPS, backed by a MariaDB database. Three services run in Docker containers:

| Service | Role | Port |
|---------|------|------|
| NGINX | Web server / entry point | 443 (HTTPS) |
| WordPress | Web application | 9000 (internal) |
| MariaDB | Database | 3306 (internal) |

Only port 443 is exposed to the outside. The other ports are internal to the Docker network.

## Starting and stopping the project

From the root of the repository:

```bash
make          # Start all services (builds images if needed)
make stop     # Pause all services without removing them
make down     # Stop and remove containers (data is preserved)
make fclean   # Full reset — removes containers, images, and all data
```

## Accessing the website

Once the stack is running, open your browser and go to:

```
https://adecauch.42.fr
```

Your browser will display a security warning because the SSL certificate is self-signed. Accept the exception to proceed.

**WordPress admin panel:**
```
https://adecauch.42.fr/wp-admin
```

Log in with the admin credentials defined in `srcs/.env`.

## Credentials

Credentials are stored in `srcs/.env` on the host machine (never committed to git). This file contains:

- `MYSQL_USER` / `MYSQL_PASSWORD` — database user for WordPress
- `MYSQL_ROOT_PASSWORD` — MariaDB root password
- `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD` — WordPress administrator account
- `WP_USER` / `WP_USER_PASSWORD` — WordPress regular user account

## Checking that services are running

```bash
docker ps
```

All three containers (`mariadb`, `wordpress`, `nginx`) should show `Up` status.

To view logs for a specific service:

```bash
docker logs mariadb
docker logs wordpress
docker logs nginx
```
