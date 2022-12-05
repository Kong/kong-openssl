#!/usr/bin/env bash

set -euo pipefail

if [ -n "${DEBUG:-}" ]; then
    set -x
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export $(grep -v '^#' $SCRIPT_DIR/.env | xargs)

function test() {
    cp -R /tmp/build/* /
    /usr/local/kong/bin/openssl version
    /usr/local/kong/bin/openssl version | grep -q $OPENSSL_VERSION
    ls -la /usr/local/kong/lib/libyaml.so
}

test
