#!/usr/bin/env bash

PROGNAME=$(basename $0)

if test -z ${ASTERISK_VERSION}; then
  echo "${PROGNAME}: ASTERISK_VERSION required" >&2
  exit 1
fi

set -ueo pipefail

useradd --system asterisk

DEBIAN_FRONTEND=noninteractive \
  apt-get update -qq

DEBIAN_FRONTEND=noninteractive \
  apt-get install --yes -qq --no-install-recommends --no-install-suggests \
  autoconf \
  binutils-dev \
  build-essential \
  ca-certificates \
  curl \
  file \
  libcurl4-openssl-dev \
  libedit-dev \
  libgsm1-dev \
  libogg-dev \
  libpopt-dev \
  libresample1-dev \
  libspandsp-dev \
  libspeex-dev \
  libspeexdsp-dev \
  libsqlite3-dev \
  libsrtp2-dev \
  libssl-dev \
  libvorbis-dev \
  libxml2-dev \
  libxslt1-dev \
  odbcinst \
  portaudio19-dev \
  procps \
  unixodbc \
  unixodbc-dev \
  uuid \
  uuid-dev \
  xmlstarlet \
  >/dev/null

DEBIAN_FRONTEND=noninteractive \
  apt-get purge --yes -qq --auto-remove >/dev/null
rm -rf /var/lib/apt/lists/*
