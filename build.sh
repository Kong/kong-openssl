#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ -n "${DEBUG:-}" ]; then
    set -x
fi

function main() {
    rm -rf /tmp/build/* && uname -a >> /tmp/build/out
}

main
