ARG SWIFT_VERSION
ARG BUILDER_DOCKER=swift:$SWIFT_VERSION

FROM $BUILDER_DOCKER as builder

RUN apt-get -qq update && apt-get -q -y install \
  libssl-dev libicu-dev

ADD assets /assets