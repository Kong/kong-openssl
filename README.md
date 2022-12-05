# Kong-OpenSSL

This repository provides pre-built openssl artifacts for use by Kong Gateway.

## Getting Started

### Updating the OpenSSL Version

Update the OpenSSL variable in the `.env` file.

### Using

Use the most recent artifact that matches your CPU architecutre and OSTYPE
from the [Releases](https://github.com/Kong/kong-openssl/releases) page or
alternatively a docker image from the [packages](https://github.com/Kong/kong-openssl/pkgs/container/kong-openssl)
page.

For example
```
#!/usr/bin/env bash

arch=$(uname -m)

KONG_OPENSSL_VER="${KONG_OPENSSL_VER:-1.1.0}"
package_architecture=x86_64
if [ "$(arch)" == "aarch64" ]; then
    package_architecture=aarch64
fi
curl --fail -sSLo openssl.tar.gz https://github.com/Kong/kong-openssl/releases/download/$KONG_OPENSSL_VER/$package_architecture-$OSTYPE.tar.gz
tar -C /tmp/build -xvf openssl.tar.gz
```

The gcr.io docker tag naming setup is:
```
ghcr.io/kong/kong-openssl:${GITHUB_RELEASE}-${ARCHITECTURE}-${OSTYPE}
# Example gcr.io/kong/kong-openssl:1.1.0-aarch64-linux-musl

ghcr.io/kong/kong-openssl:${GIT_SHA}-${ARCHITECTURE}-${OSTYPE}
# Example kong-openssl:sha-17a5f5f-aarch64-linux-gnu

ghcr.io/kong/kong-openssl:${OPENSSL_VERSION}-${ARCHITECTURE}-${OSTYPE}
# Example gcr.io/kong/kong-openssl:1.1.1s-x86_64-linux-musl
```
The OPENSSL_VERSION tag is available for convenience and it is mutable. If you use it please pin the SHA

### Building

Prerequisites:

- make
- docker w\ buildkit

```
# Set desired environment variables. If not set the below are the defaults when this document was written
ARCHITECTURE=x86_64
OSTYPE=linux-gnu
OPENSSL_VERSION=1.1.1s

make build/package
```
Will result in a local docker image and the build result in the `package` directory


The same result without `make`

```
ARCHITECTURE=x86_64
OSTYPE=linux-gnu
OPENSSL_VERSION=1.1.1s

docker buildx build \
    --build-arg ARCHITECTURE=$(ARCHITECTURE) \
    --build-arg OSTYPE=$(OSTYPE) \
    --build-arg OPENSSL_VERSION=$(OPENSSL_VERSION) \
    --target=package \
    -o package .
```


A **similar** result without `docker`

```
ARCHITECTURE=x86_64
OSTYPE=linux-gnu
OPENSSL_VERSION=1.1.1s

./build.sh

ls -la /tmp/build
```
*This will use your local compiler / linker so the result will not be
equivalent to a docker build and there's a strong chance the result will
not be compatible with all platforms we target for release*
