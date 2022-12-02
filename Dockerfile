ARG OSTYPE=linux-gnu
ARG ARCHITECTURE=x86_64
ARG DOCKER_REGISTRY=ghcr.io
ARG DOCKER_IMAGE_NAME

# List out all image permutations to trick dependabot
FROM --platform=linux/amd64 kong/kong-build-tools:apk-1.8.1 as x86_64-linux-musl
FROM --platform=linux/amd64 kong/kong-build-tools:rpm-1.8.1 as x86_64-linux-gnu
FROM --platform=linux/arm64 kong/kong-build-tools:apk-1.8.1 as aarch64-linux-musl
FROM --platform=linux/arm64 kong/kong-build-tools:rpm-1.8.1 as aarch64-linux-gnu


# Run the build script
FROM $ARCHITECTURE-$OSTYPE as build

# Keep sync'd with Makefile and release.yaml
ARG OPENSSL_VERSION="1.1.1s"
ENV OPENSSL_VERSION $OPENSSL_VERSION
COPY . /src
RUN /src/build.sh && /src/test.sh


# Copy the build result to scratch so we can export the result
FROM scratch as package

COPY --from=build /tmp/build /
