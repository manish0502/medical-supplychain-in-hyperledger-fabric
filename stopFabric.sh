docker-compose -f ./docker-compose-cli.yaml down
docker kill $(docker ps -aq)
docker rm $(docker ps -aq)
docker system prune -f
docker volume prune -f
docker rmi $(docker images dev* -q)
