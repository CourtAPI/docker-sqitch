.PHONY: build push deploy tag clean help

DOCKER_REPO := courtapi/docker-sqitch
DOCKER_TAG := $(shell git describe --tags --always --dirty)

help:
	@echo "Available commands:"
	@echo "  build   - Build the Docker image"
	@echo "  push    - Push the Docker image to Docker Hub"
	@echo "  deploy  - Build and push the Docker image"
	@echo "  tag     - Show the current tag that would be used"
	@echo "  clean   - Remove local Docker image"
	@echo "  help    - Show this help message"

tag:
	@echo $(DOCKER_TAG)

build:
	@echo "Building Docker image $(DOCKER_REPO):$(DOCKER_TAG)"
	docker build -t $(DOCKER_REPO):$(DOCKER_TAG) .
	docker tag $(DOCKER_REPO):$(DOCKER_TAG) $(DOCKER_REPO):latest

push:
	@echo "Pushing Docker image $(DOCKER_REPO):$(DOCKER_TAG)"
	docker push $(DOCKER_REPO):$(DOCKER_TAG)
	docker push $(DOCKER_REPO):latest

deploy: build push

clean:
	@echo "Removing local Docker image $(DOCKER_REPO):$(DOCKER_TAG)"
	docker rmi $(DOCKER_REPO):$(DOCKER_TAG) || true
	docker rmi $(DOCKER_REPO):latest || true