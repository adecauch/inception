# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/08 11:51:36 by adecauch          #+#    #+#              #
#    Updated: 2026/04/08 11:54:27 by adecauch         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	mysqld --user=mysql &
	pid=$!

	until mysqladmin ping --silent; do
		sleep 1
	done

	mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
	mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
	mysql -e "FLUSH PRIVILEGES;"

	kill $pid
	wait $pid

fi

exec mysqld --user=mysql
