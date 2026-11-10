NAME		= inception
COMPOSE_FILE	= srcs/docker-compose.yml
DATA_DIR	= /home/smikhail/data

all: setup up

setup:
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@echo "Data directories created at $(DATA_DIR)"

up:
	@docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:
	@docker compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@sudo rm -rf $(DATA_DIR)
	@echo "Complete cleanup finished."

re: fclean all

.PHONY: all setup up down clean fclean re
