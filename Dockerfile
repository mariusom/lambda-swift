ARG SWIFT_VERSION
ARG BUILDER_DOCKER=swift:$SWIFT_VERSION

FROM $BUILDER_DOCKER as builder

RUN apt-get -qq update && apt-get -q -y install \
  libssl-dev \
  libicu-dev \
  zip

VOLUME ["/src"]
WORKDIR /src

ADD assets /assets
ADD build.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/build.sh"]