#!/bin/bash

until mysqladmin ping -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; do
	sleep 1
done

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then

	wp core download \
		--path=/var/www/html/wordpress \
		--allow-root

	wp config create \
		--path=/var/www/html/wordpress \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb \
		--allow-root

	wp core install \
		--path=/var/www/html/wordpress \
		--url=${DOMAIN_NAME} \
		--title="Inception" \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--allow-root

	wp user create ${WP_USER} ${WP_USER_EMAIL} \
		--path=/var/www/html/wordpress \
		--role=author \
		--user_pass=${WP_USER_PASSWORD} \
		--allow-root

fi

wp plugin install redis-cache --activate \
	--path=/var/www/html/wordpress \
	--allow-root

wp config set WP_REDIS_HOST redis \
	--path=/var/www/html/wordpress \
	--allow-root

wp redis enable \
	--path=/var/www/html/wordpress \
	--allow-root

exec php-fpm8.2 -F
