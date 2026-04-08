# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/08 11:52:48 by adecauch          #+#    #+#              #
#    Updated: 2026/04/08 11:54:27 by adecauch         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/CN=${DOMAIN_NAME}"

exec nginx -g "daemon off;"
