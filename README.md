# GNU C Library Builder image for AdoptOpenJDK

This Dockerfile builds an installation of [zlib](https://zlib.net/).
The build is deliberately written to compile on
multiple architectures and is regularly tested on x86_64, ppc64le, aarch64 and
s390x machines.

The intention of the build is to provide a _libz_
implementations for the [Alpine Linux](https://alpinelinux.org/) containers
used to host [AdoptOpenJDK](https://adoptopenjdk.net/) JVMs.

## Basic usage

To use the image:

```sh
$ docker build -t openjdk-gcc-builder .
```

And in your target's Dockerfile

```
RUN mkdir -p /usr/glibc-compat
COPY --from=openjdk-gcc-builder:latest /usr/glibc-compat/. /usr/glibc-compat/lib/
```

Notice the libraries are intended to be used in concert with libraries
build from `openjdk-glib-builder`.

<!--- TODO: GO back and put in a real link to openjdk-glib-builder when it
        finds a home -->

## Adding new GCC versions

Update `shasums.txt` with the SHA-256 checksum of the zlib source archive.
Set the argument
`ZLIB_VERSION` to the target version, either by using the command line or
editing the `Dockerfile`.  Suggested best practice is to tag the build image
with the GLibC version.  For example:

```sh
$ ZLIB_VERSION=1.2.11 docker build --build-arg ZLIB_VERSION=$ZLIB_VERSION \
    -t openjdk-glibc-builder:$ZLIB_VERSION .
```
