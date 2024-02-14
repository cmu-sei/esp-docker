# Docker container for ESP use
# Copyright 2023 Carnegie Mellon University.
# MIT (SEI)
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# This material is based upon work funded and supported by the Department of
# Defense under Contract No. FA8702-15-D-0002 with Carnegie Mellon University
# for the operation of the Software Engineering Institute, a federally funded
# research and development center.
# The view, opinions, and/or findings contained in this material are those of
# the author(s) and should not be construed as an official Government position,
# policy, or decision, unless designated by other documentation.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING
# INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON
# UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
# AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR
# PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE
# MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND
# WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release
# and unlimited distribution.  Please see Copyright notice for non-US
# Government use and distribution.
# DM23-0186


FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

WORKDIR /home

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    autoconf \
    bc \
    bison \
    build-essential \
    bzip2 \
    cmake \
    cpio \
    csh \
    curl \
    device-tree-compiler \
    dh-autoreconf \
    emacs \
    environment-modules \
    file \
    flex \
    gawk \
    gcc-multilib \
    git \
    gtkwave \
    help2man \
    iverilog \
    jq \
    ksh \
    libgdbm-dev \
    libgl1-mesa-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libglu1-mesa \
    libmotif-dev \
    libmpc-dev \
    libncurses5 \
    libncurses-dev \
    libnspr4 \
    libnspr4-dev \
    libopencv-dev \
    libreadline-dev \
    libsm-dev \
    libxcursor-dev \
    libxft-dev \
    libxml-perl \
    libxpm-dev \
    libxrandr-dev \
    libxss-dev \
    libyaml-perl \
    locales \
    ninja-build \
    minicom \
    net-tools \
    octave \
    octave-io \
    patch \
    perl \
    python \
    python3 \
    python3-pip \
    python3-tk \
    qtcreator \
    rename \
    rsync \
    socat \
    software-properties-common \
    sshpass \
    sudo \
    tcl \
    texinfo \
    tig \
    tk \
    tk-dev \
    tmux \
    unzip \
    wget \
    x11-apps \
    xterm \
    xvfb \
    zlib1g-dev \
    zsh && \
    pip3 install Pmw && \
    locale-gen en_US.UTF-8 && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# -l on adduser is to handle large uids, e.g.,
# https://github.com/moby/moby/issues/5419
RUN groupadd -g 18 fpga && \
    useradd -l -ms /bin/bash espuser && \
    usermod -aG dialout espuser && \
    usermod -aG fpga espuser && \
    usermod -aG plugdev espuser && \
    usermod -aG sudo espuser && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'espuser:espuser' | chpasswd

USER espuser
WORKDIR /home/espuser
COPY --chown=espuser:espuser ./scripts/gitconfig /home/espuser/.gitconfig

RUN git clone --recursive https://github.com/sld-columbia/esp.git && \
    cd /home/espuser/esp && \
    git fetch --all --tags --prune && \
    git checkout tags/2023.1.0 -b 2023.1.0 && \
    cd /home/espuser/esp/accelerators/third-party/NV_NVDLA && \
    rm -rf ip/verif sw/prebuilt sw/regression && \
    cd /home/espuser/esp && rm -rf utils/zynq && \
    cd /home/espuser/esp && \
    (echo y; echo /home/espuser/riscv; echo 20; echo n; echo n; echo n) | bash utils/toolchain/build_riscv_toolchain.sh && rm -rf /tmp/_riscv_build

# add files.
ADD scripts ./scripts
COPY ./scripts/bash_aliases /home/espuser/.bash_aliases

# go in as root and change user in entrypoint.sh
USER root
COPY ./scripts/minirc.dfl /etc/minicom
# set entrypoint
ENTRYPOINT ["./scripts/entrypoint.sh"]
