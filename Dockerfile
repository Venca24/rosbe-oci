FROM docker.io/library/ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

ARG ROSBE_VERSION=2.2.1
ARG ROSBE_CHECKSUM="f45b936a6c4e2712bd9f3015cd8b1ec8e06612b537fbb350dc9bb55c3fcd62cb058569fba8a92cd29d413b2db4f61f6f28927d7e2c7796f0b8e8995dbf5e77c0"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    bison \
    texinfo \
    zlib1g-dev \
    python3 \
    python3-pip \
    python-is-python3 \
    wget \
    cmake \
    ninja-build \
    cpio \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/rosbe

RUN wget -q https://sourceforge.net/projects/reactos/files/RosBE-Unix/${ROSBE_VERSION}/RosBE-Unix-${ROSBE_VERSION}.tar.bz2 && \
    echo "${ROSBE_CHECKSUM}  RosBE-Unix-${ROSBE_VERSION}.tar.bz2" | sha512sum -c - && \
    tar -xjf RosBE-Unix-${ROSBE_VERSION}.tar.bz2 && \
    rm RosBE-Unix-${ROSBE_VERSION}.tar.bz2

WORKDIR /tmp/rosbe/RosBE-Unix-${ROSBE_VERSION}
RUN ./RosBE-Builder.sh /usr/local/RosBE

FROM docker.io/library/ubuntu:24.04

LABEL org.opencontainers.image.title="ReactOS Build Environment (RosBE)" \
      org.opencontainers.image.description="Containerized environment for compiling ReactOS" \
      org.opencontainers.image.authors="Václav Zouzalík <Vaclav.Zouzalik@seznam.cz>" \
      org.opencontainers.image.source="https://github.com/Venca24/rosbe-oci" \
      org.opencontainers.image.licenses="BSD-2-Clause"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python-is-python3 \
    cmake \
    ninja-build \
    bison \
    flex \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/RosBE /usr/local/RosBE

RUN mkdir -p /reactos && chown -R ubuntu:ubuntu /reactos

USER ubuntu

WORKDIR /reactos

ENTRYPOINT ["/usr/local/RosBE/RosBE.sh", "/reactos"]
