# Original: https://gist.github.com/tasuten/0431d8af3e7b5ad5bc5347ce2d7045d7
# https://github.com/ejuarezg/containers/blob/master/iosevka_font/Dockerfile

FROM archlinux

ARG OTFCC_VER=0.10.4
ARG PREMAKE_VER=5.0.0-alpha15

# Base Packages
RUN pacman -Syu --noconfirm --needed git base-devel jq file curl ca-certificates nodejs-lts-iron npm
    
# Premake
WORKDIR /tmp
RUN curl -sSLo premake5.tar.gz https://github.com/premake/premake-core/releases/download/v${PREMAKE_VER}/premake-${PREMAKE_VER}-linux.tar.gz
RUN tar xvf premake5.tar.gz
RUN mv premake5 /usr/local/bin/premake5
RUN rm premake5.tar.gz
RUN curl -sSLo otfcc.tar.gz https://github.com/caryll/otfcc/archive/v${OTFCC_VER}.tar.gz
RUN tar xvf otfcc.tar.gz
RUN mv otfcc-${OTFCC_VER} otfcc

# OTFCC
WORKDIR /tmp/otfcc
RUN premake5 gmake

WORKDIR /tmp/otfcc/build/gmake
#WORKDIR build/gmake
RUN make config=release_x64

WORKDIR /tmp/otfcc/bin/release-x64
RUN mv otfccbuild /usr/local/bin/otfccbuild
RUN mv otfccdump /usr/local/bin/otfccdump

WORKDIR /tmp
RUN rm -rf otfcc/ otfcc.tar.gz

# Creates 'build' user to build ttfautohint from the AUR
RUN useradd -m build
RUN echo 'build ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# TTFAutoHint
USER build

WORKDIR /home/build
#RUN gpg --keyserver pgp.mit.edu --recv-keys C1A60EACE707FDA5
RUN gpg --keyserver hkps://keys.openpgp.org/ --recv-keys C1A60EACE707FDA5
RUN git clone https://aur.archlinux.org/ttfautohint.git

WORKDIR /home/build/ttfautohint
RUN makepkg -si --noconfirm

# Cleanup
USER root

RUN userdel -rf build
RUN rm /var/lib/pacman/sync/*
RUN rm /var/cache/pacman/pkg/*

COPY run.sh /run.sh

WORKDIR /build
ENTRYPOINT ["/bin/bash", "/run.sh"]

