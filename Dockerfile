FROM ubuntu:18.04

#
#  Maybe these shouldn't be arguments, but I'm leaving them here
#  for documentation and potential customization purposes.  Also
#  at some point I may want to provide the Tarballs via a volume
#  mount rather than a download.
#
ARG ZLIB_PREFIX_DIR=/usr/zlib
ARG ZLIB_SRC_DIR=/zlib/src
ARG ZLIB_BUILD_DIR=/zlib/build
ARG ZLIB_VERSION=1.2.11
ARG GLIBC_COMPAT_DIR=/usr/glibc-compat

SHELL [ "bash", "-o", "pipefail", "-c" ]

RUN apt-get -q update \
	&& DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qy install \
		build-essential \
		ca-certificates \
		wget \
	&& rm -rf /var/apt/lists/*

WORKDIR /tmp
COPY shasums.txt .

RUN	wget -nv "https://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz" \
  && grep -F "$ZLIB_VERSION" shasums.txt | sha256sum -c \
	&& mkdir -p "$ZLIB_SRC_DIR" "$ZLIB_BUILD_DIR" \
	&& tar zfx zlib-$ZLIB_VERSION.tar.gz -C "$ZLIB_SRC_DIR" --strip 1 \
	&& rm zlib-$ZLIB_VERSION.tar.gz

WORKDIR $ZLIB_BUILD_DIR
RUN "$ZLIB_SRC_DIR/configure" --prefix="$ZLIB_PREFIX_DIR"
RUN make -j"$(grep -c '^processor' /proc/cpuinfo)"  all \
 	&& make -j"$(grep -c '^processor' /proc/cpuinfo)" install


RUN mkdir -p "$GLIBC_COMPAT_DIR" \
	&& find "$ZLIB_PREFIX_DIR/lib" -name 'libz*' -type f -print0 \
		| xargs -I{} -0 cp -v {} "$GLIBC_COMPAT_DIR"
