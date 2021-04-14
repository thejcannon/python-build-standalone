# Debian Stretch.
FROM debian@sha256:4b9b2ef8de1f3e9531626e8eb3d19e104e9dfde0a2b0f42b763b38235773f48e
MAINTAINER Gregory Szorc <gregory.szorc@gmail.com>

RUN groupadd -g 1000 build && \
    useradd -u 1000 -g 1000 -d /build -s /bin/bash -m build && \
    mkdir /tools && \
    chown -R build:build /build /tools

ENV HOME=/build \
    SHELL=/bin/bash \
    USER=build \
    LOGNAME=build \
    HOSTNAME=builder \
    DEBIAN_FRONTEND=noninteractive

CMD ["/bin/bash", "--login"]
WORKDIR '/build'

RUN for s in debian_stretch debian_stretch-updates debian-security_stretch/updates; do \
      echo "deb http://snapshot.debian.org/archive/${s%_*}/20210404T083057Z/ ${s#*_} main"; \
    done > /etc/apt/sources.list && \
    ( echo 'quiet "true";'; \
      echo 'APT::Get::Assume-Yes "true";'; \
      echo 'APT::Install-Recommends "false";'; \
      echo 'Acquire::Check-Valid-Until "false";'; \
      echo 'Acquire::Retries "5";'; \
    ) > /etc/apt/apt.conf.d/99cpython-portable

RUN apt-get update

# Host building.
RUN apt-get install \
    gcc \
    libc6-dev \
    libffi-dev \
    make \
    patch \
    patchelf \
    perl \
    pkg-config \
    tar \
    xz-utils \
    unzip \
    zlib1g-dev

# Cross-building.
RUN apt-get install \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi \
    gcc-arm-linux-gnueabihf \
    gcc-mips-linux-gnu \
    gcc-mips64el-linux-gnuabi64 \
    gcc-mipsel-linux-gnu \
    gcc-s390x-linux-gnu \
    libc6-dev-arm64-cross \
    libc6-dev-armel-cross \
    libc6-dev-armhf-cross \
    libc6-dev-mips-cross \
    libc6-dev-mips64el-cross \
    libc6-dev-mipsel-cross \
    libc6-dev-s390x-cross