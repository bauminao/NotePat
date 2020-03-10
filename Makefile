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


## 
venv: app/venv_app/bin/activate

## 
app/venv_app/bin/activate: app/requirements.txt
	test -d app/venv_app || python3 -m venv app/venv_app
	source app/venv_app/bin/activate; pip install -Ur app/requirements.txt 
	touch app/venv_app/bin/activate

## run local flask. You need docker-mongodb anyway.
local: venv
	printf "\n${COLOR_YELLOW}Be sure you started \"deploy\", too. "
	printf "Because you will be in need of the mongodb.\n\n${COLOR_RESET}"
	printf "Docker-version will run on port 5000, Local version will run on port 5001.\n\n"

	source app/venv_app/bin/activate ; cd app ; export FLASK_ENV=development ; flask run --host=127.0.0.1 --port=5000 

## stop docker environment
stop_docker:
	docker-compose -f deployments/docker-compose.yml down -v

## CleanUp carbage files
clean: 
	find -iname "*.pyc" -delete

## Reset full local environment
reset: clean 
	rm -rf app/venv_app
