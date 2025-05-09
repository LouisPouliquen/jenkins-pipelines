.PHONY: up down logs cli seed reset build

IMAGE_NAME = custom-jenkins:latest

build:
	docker build -t $(IMAGE_NAME) -f Dockerfile.jenkins .

up: build
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f jenkins

cli:
	curl -s -o jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

seed: cli
	bash ./setup_pipeline_b.sh

reset:
	rm -rf jenkins_home jenkins-cli.jar
	docker compose down -v
	make up
