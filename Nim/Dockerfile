FROM debian:10-slim AS base
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y && apt-get upgrade -y \
 && apt-get install -y build-essential git curl


FROM base AS musl
ARG MUSL_REPO="git://git.musl-libc.org/musl"
ARG MUSL_VERSION=latest
RUN v=$(if [ "$MUSL_VERSION" != latest ]; then echo "$MUSL_VERSION"; else git ls-remote --tags $MUSL_REPO | grep -Eo 'v[0-9]+(\.[0-9]+)+$' | sort -V | tail -1 ; fi) \
 && echo "Installing MUSL $v" >&2 \
 && git clone --depth=1 -b $v $MUSL_REPO /tmp/musl
WORKDIR /tmp/musl
RUN ./configure --prefix=/usr/local/musl --enable-optimize=size --disable-shared --enable-static --enable-wrapper \
 && make -j$(grep ^processor /proc/cpuinfo | wc -l) all \
 && make install \
 && find /usr/local/musl/bin -type f -exec ln -sv {} /usr/local/bin \;


FROM base AS nim
ARG NIM_REPO="https://github.com/nim-lang/Nim.git"
ARG NIM_VERSION=latest
RUN v=$(if [ "$NIM_VERSION" != latest ]; then echo "$NIM_VERSION"; else git ls-remote --tags $NIM_REPO | grep -Eo 'v[0-9]+(\.[0-9]+)+$' | sort -V | tail -1 ; fi) \
 && echo "Installing Nim $v" >&2 \
 && u="https://nim-lang.org/download/nim-${v#v}.tar.xz" \
 && mkdir /tmp/nim \
 && curl -L $u | tar xJ --strip-components=1 -C /tmp/nim
WORKDIR /tmp/nim
RUN make -f makefile -j $(grep ^processor /proc/cpuinfo | wc -l) \
 && ./bin/nim c -d:release koch.nim \
 && ./koch tools \
 && ./install.sh /usr/local \
 && install -o0 -g0 -m755 ./bin/* /usr/local/nim/bin \
 && sed -i~ '/^cc =/a @if musl:\n gcc.exe = "musl-gcc"\n gcc.linkerexe = "musl-gcc"\n@end' /usr/local/nim/config/nim.cfg \
 && find /usr/local/nim/bin -type f -exec ln -sv {} /usr/local/bin \;

RUN export PATH=/usr/local/nim/bin:$PATH \
 && nimble refresh \
 && nimble install inim \
 && install -v -m755 -o0 -g0 $(find ~/.nimble/pkgs -name inim) /usr/local/bin/bin

FROM base
MAINTAINER "Gustavo Cordova <gustavo.cordova@gmail.com>"
CMD ["/bin/bash", "-l"]
COPY --from=musl --chown=0:0 /usr/local/ /usr/local/
COPY --from=nim  --chown=0:0 /usr/local/ /usr/local/
COPY --chown=0:0 ./help.sh /usr/local/bin/help

