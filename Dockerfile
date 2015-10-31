FROM ubuntu:14.04

RUN mkdir /code
WORKDIR /code

RUN apt-get update -qqy && apt-get install -qqy \
                ca-certificates \
                git curl wget \
                libprotobuf-dev \
                protobuf-compiler \
        --no-install-recommends && \
        apt-get -qqy clean && rm -rf /var/lib/apt/lists/*

RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
RUN git clone https://github.com/torch/distro.git torch --recursive
RUN bash torch/install.sh
ENV PATH=$PATH:/code/torch/install/bin/

RUN luarocks install loadcaffe

#RUN wget http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/rpmdeb/cuda-repo-ubuntu1410-7-0-local_7.0-28_amd64.deb
#RUN dpkg -i cuda-repo-ubuntu1410-7-0-local_7.0-28_amd64.deb
#RUN apt-get update -qqy && apt-get install -qqy \
#                cuda \
#        --no-install-recommends && \
#        apt-get -qqy clean && rm -rf /var/lib/apt/lists/*
#RUN luarocks install cutorch
#RUN luarocks install cunn

RUN git clone https://github.com/jcjohnson/neural-style.git
RUN sh neural-style/models/download_models.sh

WORKDIR /code/neural-style
CMD ["/bin/bash"]