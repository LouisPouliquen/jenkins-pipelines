.PHONY: up down logs cli seed reset build

IMAGE_NAME = custom-jenkins:latest

# 1. Build the Jenkins image
build:
	docker build -t $(IMAGE_NAME) -f Dockerfile.jenkins .

# 2. Start Jenkins with the built image
up: build
	docker compose up -d

# 3. Stop Jenkins
down:
	docker compose down

# 4. Tail logs
logs:
	docker compose logs -f jenkins

# 5. Download Jenkins CLI
cli:
	curl -s -o jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

# 6. Create Jenkins job from CLI
seed: cli
	bash ./setup_pipeline_b.sh

# 7. Full reset
reset:
	rm -rf jenkins_home jenkins-cli.jar multibranch-config.xml
	docker compose down -v
	make up
