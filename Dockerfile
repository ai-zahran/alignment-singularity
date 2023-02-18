FROM python:3.8-slim-buster

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends --quiet \
    unzip \
    git-all

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        g++ \
        gcc-multilib \
        libx11-dev \
        make \
        automake \
        autoconf \
        bzip2 \
        unzip \
        wget \
        sox \
        libtool \
        git \
        subversion \
        python2.7 \
        zlib1g-dev \
        gfortran \
        ca-certificates \
        patch \
        ffmpeg

RUN mkdir /codes
ADD htk.tar.gz /codes/

WORKDIR /codes/htk/

RUN export CPPFLAGS=-UPHNALG
RUN ./configure
RUN make all
RUN make install
WORKDIR /
# RUN rm -r /codes/

RUN rm -rf /var/lib/apt/lists/*