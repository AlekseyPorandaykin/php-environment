#Поднять проект локально
up: docker-compose.yml
	docker-compose up -d

#Пересоздать образы, почистить кэш
recreate: docker-compose.yml
	docker-compose rm -f
	docker-compose pull
	docker-compose up --build -d
#Показать все контейнеры
ps: docker-compose.yml
	docker-compose ps

#Остановить проект
down: docker-compose.yml
	docker-compose down

clear-redis: docker-compose.yml
	docker-compose exec redis redis-cli FLUSHALL

