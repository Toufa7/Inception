all:
	@docker-compose -f ./srcs/docker-compose.yml up --build 

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re:
	@docker-compose -f ./srcs/docker-compose.yml up --build

clean:
	docker stop $(docker ps -aq) \
	&& docker rm $(docker ps -aq) \
	&& docker rmi $(docker images -aq) \
	&& docker volume prune -af \
	&& docker network prune -f \
	&& docker system prune -af