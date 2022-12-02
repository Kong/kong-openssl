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

function test() {
    cp -R /tmp/build/* /
    /usr/local/kong/bin/openssl version
    /usr/local/kong/bin/openssl version | grep -q $OPENSSL_VERSION
}

test
