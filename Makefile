VERSION ?= 0.0.1
SWIFT_VERSION ?= 5.1.2
REPO ?= mariusomdev/lambda-swift
TAG ?= "$(REPO):$(VERSION)-swift-$(SWIFT_VERSION)"

publish: build
	@docker push $(TAG)
	@docker push $(REPO):latest

build:
	@docker build --build-arg SWIFT_VERSION=$(SWIFT_VERSION) -t $(TAG) .
	@docker tag $(TAG) $(REPO):latest

debug:	build
	@docker run --rm -it \
		-v ${PWD}:/src \
		--workdir "/src/" \
		--entrypoint=/bin/bash \
		$(REPO)
