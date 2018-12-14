#!/bin/sh

set -eu

zlib_version=${ADOPTOPENJDK_ZLIB_VERSION:-1.2.11}
target_registry=${ADOPTOPENJDK_TARGET_REGISTRY:-adoptopenjdk}

docker build --build-arg ZLIB_VERSION="$zlib_version" \
  -t "$target_registry/openjdk-zlib-builder:${zlib_version}-$(uname -m)" \
  ./builder-image/.

docker push "$target_registry/openjdk-zlib-builder:${zlib_version}-$(uname -m)"
