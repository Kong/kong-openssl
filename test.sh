#!/usr/bin/env bash

set -euo pipefail

if [ -n "${DEBUG:-}" ]; then
    set -x
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export $(grep -v '^#' $SCRIPT_DIR/.env | xargs)

function test() {
    echo '--- testing openssl ---'
    cp -R /tmp/build/* /
    mv /tmp/build /tmp/buffer # Check we didn't link dependencies to `/tmp/build/...`

    /usr/local/kong/bin/openssl version
    /usr/local/kong/bin/openssl version | grep -q $OPENSSL_VERSION
    ldd /usr/local/kong/lib/libyaml.so

    mv /tmp/buffer /tmp/build
    echo '--- tested openssl ---'
}

test
