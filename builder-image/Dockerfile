FROM ubuntu:18.04

#
#  These are more parameters for documentation purposes and are unlikely
#  to be changed from the command line.
#
ARG ZLIB_PREFIX_DIR=/usr/zlib
ARG ZLIB_SRC_DIR=/builder/src
ARG ZLIB_BUILD_DIR=/builder/build
ARG GLIBC_COMPAT_DIR=/usr/glibc-compat

#
#  Don't mess with this.  We use pipelines in the RUN steps and we want failures
#  to propagate outward to the &&s
#
SHELL [ "bash", "-o", "pipefail", "-c" ]

#
#  'build-essentials' may be overkill, but not by much.  Maybe someone in a
#  good mood will care to experiment.
#
RUN apt-get -q update \
	&& DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qy install \
		build-essential \
		ca-certificates \
		wget \
	&& rm -rf /var/apt/lists/*

#
#  This is likely to be changed, though one should try to match the tag
#  to the argument.  To wit:
#
#    ZLIB_VERSION=1.2.11 docker build --build-arg ZLIB_VERSION=$ZLIB_VERSION \
#        --tag openjdk-zlib-build:$ZLIB_VERSION
#
ARG ZLIB_VERSION=1.2.11

#
#  Download zlib, check to make sure the server wasn't hacked, and unpack
#  it into the source directory.
#
WORKDIR /tmp
COPY shasums.txt .
RUN	wget -nv "https://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz" \
  && grep -F "$ZLIB_VERSION" shasums.txt | sha256sum -c \
	&& mkdir -p "$ZLIB_SRC_DIR" "$ZLIB_BUILD_DIR" \
	&& tar zfx "zlib-$ZLIB_VERSION.tar.gz" -C "$ZLIB_SRC_DIR" --strip 1 \
	&& rm "zlib-$ZLIB_VERSION.tar.gz"

#
#  Configure and build zlib.  Nothing too fancy going on here
#
WORKDIR $ZLIB_BUILD_DIR
RUN "$ZLIB_SRC_DIR/configure" --prefix="$ZLIB_PREFIX_DIR"
RUN make -j"$(grep -c '^processor' /proc/cpuinfo)"  all \
 	&& make -j"$(grep -c '^processor' /proc/cpuinfo)" install


#
#  This is specific to OpenJDK -- extract the two libraries actually used.
#  Don't both with symlinks because `ldconfig` will reconstruct them on the
#  other end.
#
RUN mkdir -p "$GLIBC_COMPAT_DIR" \
	&& find "$ZLIB_PREFIX_DIR/lib" -name 'libz*' -type f -print0 \
		| xargs -I{} -0 cp -v {} "$GLIBC_COMPAT_DIR"
