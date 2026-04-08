# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/08 11:52:56 by adecauch          #+#    #+#              #
#    Updated: 2026/04/08 11:54:27 by adecauch         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 443

ENTRYPOINT ["/init.sh"]
