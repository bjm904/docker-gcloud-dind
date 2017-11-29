DOCKER_REPOSITORY := youdowell/gcloud-dind
PACKAGE_VERSION := $(shell node -pe "require('./package.json').version")
VERSION ?= $(PACKAGE_VERSION)

.PHONY: all build release info
all: build

info:
	$(info DOCKER_REPOSITORY=$(DOCKER_REPOSITORY))
	$(info VERSION=$(VERSION))

build:
	docker build -t $(DOCKER_REPOSITORY):$(VERSION) --rm .

docker-publish:
	@if ! docker images $(DOCKER_REPOSITORY):$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(DOCKER_REPOSITORY) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(DOCKER_REPOSITORY):$(VERSION)

docker-release: docker-publish
	docker tag $(DOCKER_REPOSITORY):$(VERSION) $(DOCKER_REPOSITORY):latest
	docker push $(DOCKER_REPOSITORY):latest
