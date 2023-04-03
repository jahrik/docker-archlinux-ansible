.EXPORT_ALL_VARIABLES:
IMAGE = "jahrik/docker-archlinux-ansible"
TAG = latest

all: build

build:
	@docker build \
		--ulimit nofile=1024:524288 \
		-t ${IMAGE}:$(TAG) .

push:
	@docker push ${IMAGE}:$(TAG)

.PHONY: all build push deploy
