ARG DOCKER_VERSION=20.10.17-dind

FROM docker:$DOCKER_VERSION
#FROM gitit103.jfrog.io/default-docker-virtual/pit/ubi8-jdk-11:v1 as buildx_image
RUN apk update
RUN apk add curl bash tar gzip procps wget gzip tar tzdata vim wget which unzip findutils make git grep
  #RHEL8 > RUN apk add tar gzip bind-utils procps wget bind-libs bind-libs-lite bind-license bind-utils expat fstrm gdbm gdbm-libs geolite2-city geolite2-country gpm-libs gzip libmaxminddb libmetalink libnsl2 libtirpc platform-python platform-python-pip platform-python-setuptools procps-ng protobuf-c python3-bind python3-libs python3-pip-wheel python3-ply python3-setuptools-wheel tar tzdata vim-common vim-enhanced vim-filesystem vim-minimal wget which unzip findutils make git

RUN curl -L https://services.gradle.org/distributions/gradle-6.9.1-bin.zip -o gradle-6.9.1-bin.zip \
  && unzip gradle-6.9.1-bin.zip -d /apps/ \
  && rm -f gradle-6.9.1-bin.zip

## JDK JAVA
# THIS IS FOR RHEL ONLY - ADD java-11-openjdk-11.0.17.0.8-2.portable.jdk.el.x86_64.tar.xz /apps/
RUN apk add openjdk11-jdk

#RUN curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
RUN curl -vsSLk --max-time 2 --retry 5 --retry-delay 1 --retry-max-time 10 -O https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
  && ls -alh get-helm-3 \
  && bash get-helm-3

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV GRADLE_HOME "/apps/gradle-6.9.1"
ENV PATH="${PATH}:${JAVA_HOME}/bin:${GRADLE_HOME}/bin"

# apply common metadata labels (these should be overwritten by child images)
LABEL pit.schema-version="1.0"
LABEL pit.name="pit-dind"
LABEL pit.description="PIT Base OS image for Red Hat Enterprise Linux."
LABEL pit.version="1.1"
LABEL pit.build-date="${BUILD_DATE}"
LABEL pit.vcs-url="${VCS_URL}"
LABEL pit.vcs-ref="${VCS_REF}"

##ENTRYPOINT [ "/usr/local/bin/docker" , "buildx"]
#ENTRYPOINT [ "/usr/local/bin/docker" ]
ENTRYPOINT [ "/usr/local/bin/dockerd-entrypoint.sh" ]

#CMD ["version"]
