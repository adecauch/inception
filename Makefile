# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adecauch <adecauch@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/08 11:47:42 by adecauch          #+#    #+#              #
#    Updated: 2026/04/08 12:09:07 by adecauch         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DATA_DIR	= /home/$(USER)/data

all:
	mkdir -p $(DATA_DIR)/db $(DATA_DIR)/wordpress
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

stop:
	docker-compose -f srcs/docker-compose.yml stop

clean: down
	docker system prune -f
	su -c "rm -rf $(DATA_DIR)"

fclean: clean
	docker system prune -af --volumes

re: fclean all

.PHONY: all down stop clean fclean re

#test salut
