.PHONY: up
up:
	docker-compose up -d web

.PHONY: down
down:
	docker-compose down

.PHONY: iex
iex:
	docker-compose exec web iex -S mix

.PHONY: setup
setup:
	docker-compose exec db mysql -uroot -proot -e "CREATE DATABASE open_hand_tracker_test"
	docker-compose exec -e MIX_ENV=test web mix ecto.setup

.PHONY: test
test:
	docker-compose exec -e MIX_ENV=test web mix test

.PHONY: shell
shell:
	docker-compose exec web /bin/bash
