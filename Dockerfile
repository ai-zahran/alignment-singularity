FROM continuumio/miniconda3

RUN conda create -n aligner -c conda-forge montreal-forced-aligner

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

# # Install Kaldi
# RUN ln -s /usr/bin/python2.7 /usr/bin/python

# RUN git clone --depth 1 https://github.com/kaldi-asr/kaldi.git /opt/kaldi && \
#     cd /opt/kaldi/tools && \
#     ./extras/install_mkl.sh && \
#     make -j $(nproc) && \
#     cd /opt/kaldi/src && \
#     ./configure --shared --use-cuda && \
#     make depend -j $(nproc) && \
#     make -j $(nproc) && \
#     find /opt/kaldi  -type f \( -name "*.o" -o -name "*.la" -o -name "*.a" \) -exec rm {} \; && \
#     find /opt/intel -type f -name "*.a" -exec rm {} \; && \
#     find /opt/intel -type f -regex '.*\(_mc.?\|_mic\|_thread\|_ilp64\)\.so' -exec rm {} \; && \
#     rm -rf /opt/kaldi/.git

# ENV KALDI_ROOT=/opt/kaldi
# RUN [ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh
# RUN echo ". $KALDI_ROOT/tools/env.sh" >> ~/.bashrc

# ENV PATH=$KALDI_ROOT/egs/wsj/s5/utils/:$KALDI_ROOT/tools/openfst/bin:$KALDI_ROOT/egs/wsj/s5:$PATH
# RUN [ ! -f $KALDI_ROOT/tools/config/common_path.sh ] && echo >&2 "The standard file $KALDI_ROOT/tools/config/common_path.sh is not present -> Exit!" && exit 1
# RUN $KALDI_ROOT/tools/config/common_path.sh
# RUN echo ". $KALDI_ROOT/tools/config/common_path.sh" >> ~/.bashrc

# ENV LC_ALL=C
# ENV PYTHONUNBUFFERED=1

# # Install Montreal Forced Aligner
# RUN pip install pykaldi pgvector pynini hdbscan
# RUN pip install Montreal-Forced-Aligner
# RUN mfa model download acoustic english_us_arpa
# RUN mfa model download dictionary english_us_arpa

RUN rm -rf /var/lib/apt/lists/*