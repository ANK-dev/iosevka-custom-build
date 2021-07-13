FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential curl

# NodeJS >= 14.0
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - 
RUN apt-get install -y nodejs

# ttfautohint >= 1.8.3
RUN apt-get install -y ttfautohint 

# otfcc depends on premake5
WORKDIR /tmp
RUN curl -sLo premake5.tar.gz https://github.com/premake/premake-core/releases/download/v5.0.0-alpha15/premake-5.0.0-alpha15-linux.tar.gz
RUN tar xvf premake5.tar.gz && mv premake5 /usr/local/bin/premake5 && rm premake5.tar.gz

# otfcc
WORKDIR /tmp
RUN curl -sLo otfcc.tar.gz https://github.com/caryll/otfcc/archive/v0.10.4.tar.gz
RUN tar xvf otfcc.tar.gz && mv otfcc-0.10.4 otfcc
WORKDIR /tmp/otfcc
RUN premake5 gmake && cd build/gmake && make config=release_x64
WORKDIR /tmp/otfcc/bin/release-x64
RUN mv otfccbuild /usr/local/bin/otfccbuild
RUN mv otfccdump /usr/local/bin/otfccdump
WORKDIR /tmp
RUN rm -rf otfcc/ otfcc.tar.gz

ADD main.sh /
RUN chmod +x /main.sh
ENTRYPOINT ["/bin/bash", "/main.sh"]
