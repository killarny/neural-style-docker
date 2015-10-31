FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
                ca-certificates \
                git curl wget \
                libprotobuf-dev \
                protobuf-compiler \
        --no-install-recommends && \
        apt-get -y clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /code
WORKDIR /code
RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash
RUN git clone https://github.com/torch/distro.git torch --recursive
WORKDIR /code/torch
RUN bash install.sh
ENV PATH=$PATH:/code/torch/install/bin/
WORKDIR /code
RUN /code/torch/install/bin/luarocks install loadcaffe
RUN git clone https://github.com/jcjohnson/neural-style.git
WORKDIR /code/neural-style
RUN sh models/download_models.sh

WORKDIR /code
RUN wget http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/rpmdeb/cuda-repo-ubuntu1410-7-0-local_7.0-28_amd64.deb
RUN dpkg -i cuda-repo-ubuntu1410-7-0-local_7.0-28_amd64.deb
RUN apt-get -y clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
                cuda \
        --no-install-recommends
RUN /code/torch/install/bin/luarocks install cutorch
RUN /code/torch/install/bin/luarocks install cunn

WORKDIR /code/neural-style
CMD ["/bin/bash"]