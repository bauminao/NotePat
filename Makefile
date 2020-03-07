.SILENT:
.DEFAULT_GOAL := help

COLOR_RESET = \033[0m
COLOR_COMMAND = \033[36m
COLOR_YELLOW = \033[33m
COLOR_GREEN = \033[32m
COLOR_RED = \033[31m

PROJECT := NotePat

SHELL := /bin/bash

## Installs a development environment
install: deploy

## Composes project using docker-compose
deploy:
	docker-compose -f deployments/docker-compose.yml build
	docker-compose -f deployments/docker-compose.yml down -v
	docker-compose -f deployments/docker-compose.yml up -d --force-recreate

## Prints help message
help:
	printf "\n${COLOR_YELLOW}${PROJECT}\n------\n${COLOR_RESET}"
	awk '/^[a-zA-Z\-\_0-9\.%]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "${COLOR_COMMAND}$$ make %s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort
	printf "\n"

run_local:
	printf "\n${COLOR_YELLOW}Be sure you started \"deploy\", too. "
	printf "Because you will be in need of the mongodb.\n\n${COLOR_RESET}"
	printf "Docker-version will run on port 5000, Local version will run on port 5001.\n\n"

	source app/venv_app/bin/activate && cd app && flask run --host=0.0.0.0 --port=5001

stop_docker:
	docker-compose -f deployments/docker-compose.yml down -v
