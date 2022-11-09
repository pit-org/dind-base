ARG DOCKER_VERSION=20.10.14

FROM docker:$DOCKER_VERSION
FROM gitit103.jfrog.io/default-docker-virtual/pit/ubi8-jdk-11:v1 as buildx_image

# apply common metadata labels (these should be overwritten by child images)
LABEL pit.schema-version="1.0"
LABEL pit.name="pit-dind"
LABEL pit.description="PIT Base OS image for Red Hat Enterprise Linux."
LABEL pit.version="1.1"
LABEL pit.build-date="${BUILD_DATE}"
LABEL pit.vcs-url="${VCS_URL}"
LABEL pit.vcs-ref="${VCS_REF}"

ENTRYPOINT [ "/usr/local/bin/docker" , "buildx"]
#ENTRYPOINT [ "/usr/local/bin/docker" ]

CMD ["version"]
