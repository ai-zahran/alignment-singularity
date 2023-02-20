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

# Install HTK 3.4
RUN mkdir /codes
ADD htk.tar.gz /codes/

WORKDIR /codes/htk/

RUN export CPPFLAGS=-UPHNALG
RUN ./configure  --disable-hlmtools --disable-hslab
RUN make all
RUN make install
WORKDIR /
RUN rm -r /codes/

RUN git clone https://github.com/jaekookang/p2fa_py3.git

RUN pip install Montreal-Forced-Aligner

RUN rm -rf /var/lib/apt/lists/*