# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/10 11:38:29 by adecauch          #+#    #+#              #
#    Updated: 2026/04/10 11:45:59 by adecauch         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

ARG TARGETARCH

RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/portainer/portainer/releases/download/2.21.5/portainer-2.21.5-linux-${TARGETARCH}.tar.gz \
    -O /tmp/portainer.tar.gz \
    && tar -xzf /tmp/portainer.tar.gz -C /opt \
    && rm /tmp/portainer.tar.gz

EXPOSE 9000 8000

CMD ["/opt/portainer/portainer"]
