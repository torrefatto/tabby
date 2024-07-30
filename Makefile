DOCKER ?= docker
ORG ?= torrefatto
TAG ?= cuda-12.2.0
IMAGE ?= $(ORG)/tabby:$(TAG)

.PHONY: build
build:
	$(DOCKER) build -t $(IMAGE) .

.PHONY: build-dev
build-dev:
	BUILDX_EXPERIMENTAL=1 \
	$(DOCKER) buildx debug \
		--invoke /bin/bash \
		--on=error \
		build \
		--progress=plain \
		-t $(IMAGE)-dbg .
