#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ -n "${DEBUG:-}" ]; then
    set -x
fi

if [[ -z "$OPENSSL_VERSION" ]]; then
    echo "Must provide OPENSSL_VERSION in environment" 1>&2
    exit 1
fi

function main() {
    mkdir -p /tmp/build
    rm -rf /tmp/build/*
    curl --fail -sSLo openssl.tar.gz "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
    tar -xzvf openssl.tar.gz
    pushd openssl-${OPENSSL_VERSION}
        eval ./config \
            -g shared \
            -DPURIFY no-threads \
            --prefix=/usr/local/kong \
            --openssldir=/usr/local/kong no-unit-test '-Wl,-rpath,'\''$(LIBRPATH)'\'',--enable-new-dtags' && \
        make -j2 && \
        make install_sw DESTDIR=/tmp/build
    popd
}

main
