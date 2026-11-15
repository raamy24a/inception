all: build up

build:
	@mkdir -p /home/radib/data/mariadb
	@mkdir -p /home/radib/data/wordpress
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -a --volumes -f

fclean: clean
	@rm -rf /home/radib/data/mariadb/*
	@rm -rf /home/radib/data/wordpress/*

re: fclean all

.PHONY: all build up down clean fclean re
