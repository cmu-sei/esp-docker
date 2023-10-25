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


FROM centos:7

SHELL ["/bin/bash", "-c"]

WORKDIR /home

# package list from
#https://github.com/sld-columbia/esp-docker/blob/master/Dockerfile.centos7_full
RUN yum update -y && \
    yum install -y \
    autoconf \
    automake \
    bc \
    bison \
    bzip2 \
    chrpath \
    csh \
    diffstat \
    dtc \
    emacs \
    file \
    flex \
    gcc \
    gcc-c++ \
    gdbm-devel \
    gdbm-devel.i686 \
    git \
    glib2-devel \
    glibc-devel \
    glibc-devel.i686 \
    glibc-static \
    glibc-static.i686 \
    help2man \
    java \
    ksh \
    libmpc-devel \
    libmpc-devel.i686 \
    libtool \
    libSM \
    libSM.i686 \
    libXcursor \
    libXcursor.i686 \
    libXft \
    libXft.i686 \
    libXp \
    libXp.i686 \
    libXrandr \
    libXrandr.i686 \
    libXScrnSaver \
    libXScrnSaver.i686 \
    mesa-dri-drivers \
    mesa-dri-drivers.i686 \
    mesa-libGL.i686 \
    mesa-libGLU.i686 \
    mesa-libGL \
    mesa-libGLU \
    minicom \
    ncurses \
    net-tools \
    nspr \
    nspr.i686 \
    nspr-devel \
    nspr-devel.i686 \
    openmotif \
    patch \
    perl \
    perl-Capture-Tiny \
    perl-Env \
    perl-ExtUtils-MakeMaker \
    perl-Thread-Queue \
    perl-XML-Simple \
    perl-YAML \
    python \
    python-pip \
    python3 \
    python3-pip \
    python3-tkinter \
    readline-devel \
    readline-devel.i686 \
    socat \
    sudo \
    tcl \
    texinfo \
    texinfo-tex \
    tk \
    tk-devel \
    tmux \
    unzip \
    vim \
    which \
    wget \
    xorg-x11-apps \
    xterm \
    Xvfb \
    zsh

RUN ln -s /lib64/libtiff.so.5 /lib64/libtiff.so.3 && \
    ln -s /usr/lib64/libmpc.so.3 /usr/lib64/libmpc.so.2 && \
    pip3 install Pmw

# -l on adduser is to handle large uids, e.g.,
# https://github.com/moby/moby/issues/5419

#  groupadd -g 18 fpga && \
#  usermod -aG fpga espuser && \
#  usermod -aG plugdev espuser && \
#  usermod -aG sudo espuser && \

RUN useradd -l -ms /bin/bash espuser && \
    usermod -aG dialout espuser && \
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
    cd /home/espuser/esp && rm -rf utils/zynq

RUN cd /home/espuser/esp && \
    (echo y; echo /home/espuser/riscv; echo 20; echo n; echo n; echo n) | bash utils/toolchain/build_riscv_toolchain.sh && rm -rf /tmp/_riscv_build

# add files.
ADD scripts ./scripts
COPY ./scripts/bash_aliases /home/espuser/.bash_aliases
RUN echo ". ~/.bash_aliases" >> ~/.bashrc

# go in as root and change user in entrypoint.sh
USER root
COPY ./scripts/minirc.dfl /etc/minicom
RUN mkdir -p /afs/ece.cmu.edu/support/cds && \
    mkdir -p /afs/ece.cmu.edu/support/xilinx

# set entrypoint
ENTRYPOINT ["./scripts/entrypoint.sh"]
