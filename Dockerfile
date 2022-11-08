ARG ALPINE_VERSION=3.15.4
ARG BUILDX_VERSION=0.8.2
ARG DOCKER_VERSION=20.10.14

FROM docker/buildx-bin:$BUILDX_VERSION as buildx_bin

FROM alpine:$ALPINE_VERSION as buildx_strip

COPY --from=buildx_bin /buildx /
RUN apk add -U binutils && strip /buildx

#FROM docker:$DOCKER_VERSION as buildx_image
FROM gitit103.jfrog.io/default-docker-virtual/pit/ubi8-jdk-11:v1 as buildx_image

ARG DOCKER_CONFIG=/env_configs/.docker

ENV DOCKER_CONFIG=$DOCKER_CONFIG \
    DOCKER_CLI_EXPERIMENTAL=enabled

WORKDIR $DOCKER_CONFIG/cli-plugins

COPY --from=buildx_strip /buildx ./docker-buildx

# apply common metadata labels (these should be overwritten by child images)
LABEL pit.schema-version="1.0"
LABEL pit.name="pit-dind"
LABEL pit.description="PIT Base OS image for Red Hat Enterprise Linux."
LABEL pit.version="1.1"
LABEL pit.build-date="${BUILD_DATE}"
LABEL pit.vcs-url="${VCS_URL}"
LABEL pit.vcs-ref="${VCS_REF}"

ENTRYPOINT [ "/usr/local/bin/docker" , "buildx"]

CMD ["version"]
