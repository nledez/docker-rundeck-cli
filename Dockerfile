FROM --platform=$BUILDPLATFORM ubuntu:20.04

ARG TARGETOS TARGETPLATFORM TARGETARCH

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ARG RD_VERSION=2.0.3

# Update image apt packages
USER root

## BASH
RUN echo "dash dash/sh boolean false" | debconf-set-selections \
    && dpkg-reconfigure dash

## General package configuration
RUN set -euxo pipefail \
    && apt-get -y update && apt-get upgrade -y && apt-get -y --no-install-recommends install \
        openjdk-11-jdk-headless \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    # Setup rundeck user
    && adduser --gid 0 --shell /bin/bash --home /home/rundeck --gecos "" --disabled-password rundeck \
    && chmod 0775 /home/rundeck \
    && passwd -d rundeck \
    && addgroup rundeck sudo \
    && chmod g+w /etc/passwd

RUN wget https://github.com/rundeck/rundeck-cli/releases/download/v${RD_VERSION}/rundeck-cli_${RD_VERSION}-1_all.deb && \
	dpkg -i rundeck-cli_${RD_VERSION}-1_all.deb && \
	rm rundeck-cli_${RD_VERSION}-1_all.deb

USER rundeck

WORKDIR /home/rundeck

# ENTRYPOINT [ "/tini", "--", "docker-lib/entry.sh" ]
