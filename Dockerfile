FROM ubuntu:18.04
MAINTAINER Jonathan Springer <jonpspri@gmail.com>

#
#  Maybe these shouldn't be arguments, but I'm leaving them here
#  for documentation and potential customization purposes.  Also
#  at some point I may want to provide the Tarballs via a volume
#  mount rather than a download.
#
ARG TARBALL_DIR=/tarballs

ARG ZLIB_PREFIX_DIR=/usr/zlib
ARG ZLIB_SRC_DIR=/zlib/src
ARG ZLIB_BUILD_DIR=/zlib/build

SHELL [ "bash", "-o", "pipefail", "-c" ]

RUN apt-get -q update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qy install \
		build-essential \
		wget

RUN mkdir -p $TARBALL_DIR $ZLIB_SRC_DIR
WORKDIR $TARBALL_DIR
COPY shasums.txt .

#
#  These args are down here so Docker doesn't have to redo the Ubuntu apt
#  gets whenever it's compiling a different version combination
#
ARG ZLIB_VERSION=1.2.11

#
#  If the files exist, don't download them again (volume mount), otherwise
#  check them against the SHA sums that are expected.
#
#  I don't know how to get docker to persist things on an internal volume if
#  I don't declare one for the build, so I am going to pass on that for now.
#
RUN test -f zlibc-$ZLIB_VERSION.tar.gz || \
			wget -nv "https://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz"

RUN fgrep "$ZLIB_VERSION" shasums.txt | sha256sum -c \
	&& tar zfx zlib-$ZLIB_VERSION.tar.gz -C "$ZLIB_SRC_DIR" --strip 1

WORKDIR $ZLIB_BUILD_DIR
RUN "$ZLIB_SRC_DIR/configure" --prefix="$ZLIB_PREFIX_DIR"
RUN make -j$(grep -c '^processor' /proc/cpuinfo)  all
RUN make -j$(grep -c '^processor' /proc/cpuinfo)  install
#RUN cd $ZLIB_SRC_DIR && cp COPYING.LIB LICENSES $ZLIB_PREFIX_DIR

ARG TARGET_TARBALL=/openjdk-zlibc-$ZLIB_VERSION.tar.gz
RUN cd $ZLIB_PREFIX_DIR && tar --hard-dereference -zcf "$TARGET_TARBALL" .
