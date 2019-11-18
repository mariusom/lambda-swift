VERSION ?= 0.0.6
SWIFT_VERSION ?= 5.1.2
REPO ?= mariusomdev/lambda-swift
TAG ?= "$(REPO):$(VERSION)-swift-$(SWIFT_VERSION)"

publish: build
	@docker push $(TAG)
	@docker push $(REPO):latest
	@docker push $(REPO):latest-swift-$(SWIFT_VERSION)

build:
	@docker build --build-arg SWIFT_VERSION=$(SWIFT_VERSION) -t $(TAG) .
	@docker tag $(TAG) $(REPO):latest
	@docker tag $(TAG) $(REPO):latest-swift-$(SWIFT_VERSION)

debug:	build
	@docker run --rm -it \
		-v ${PWD}:/src \
		--workdir "/src/" \
		--entrypoint=/bin/bash \
		$(REPO)
