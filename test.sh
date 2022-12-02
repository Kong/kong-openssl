#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ -n "${DEBUG:-}" ]; then
    set -x
fi

function test() {
    ls -lah /tmp/build/out
}

test
