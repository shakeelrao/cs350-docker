FROM ubuntu:14.04
MAINTAINER Shakeel Rao <shakeelrao79@gmail.com>

# minimal system requirements to install sys161
RUN apt-get update \
    && apt-get install -y \
            curl \
            gcc-4.9 \
            make \
            libncurses5-dev

# download cs350 archives
WORKDIR /root/archive
RUN curl -L http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161-binutils.tar.gz | tar xz \
    && curl -L http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161-gcc.tar.gz | tar xz \
    && curl -L http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161-gdb.tar.gz | tar xz \
    && curl -L http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161-bmake.tar.gz | tar xz \
    && curl -L http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/sys161.tar.gz | tar xz

# install binutils
WORKDIR /root/archive/binutils-2.17+os161-2.0.1
RUN ./configure \
        --nfp \
        --disable-werror \
        --target=mips-harvard-os161 \
        --prefix=/root/sys161/tools \
    && make \
    && make install

# modify PATH to include sys161 tools
RUN mkdir /root/sys161/bin
ENV PATH=/root/sys161/bin:/root/sys161/tools/bin:$PATH

# install GCC MIPS cross-compiler
WORKDIR /root/archive/gcc-4.1.2+os161-2.0
RUN ./configure \
        -nfp \
        --disable-shared \
        --disable-threads \
        --disable-libmudflap \
        --disable-libssp \
        --target=mips-harvard-os161 \
        --prefix=/root/sys161/tools \
    && make \
    && make install

# install GDB
WORKDIR /root/archive/gdb-6.6+os161-2.0
RUN ./configure \
        --target=mips-harvard-os161 \
        --prefix=/root/sys161/tools \
        --disable-werror \
    && make \
    && make install

# install bmake
WORKDIR /root/archive/bmake
RUN curl -L http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161-mk.tar.gz | tar xz \
    && ./boot-strap --prefix=/root/sys161/tools | sed '1,/Commands to install into \/root\/sys161\/tools\//d' | bash

# set-up links to toolchain binaries
WORKDIR /root/sys161/tools/bin
RUN sh -c 'for i in mips-*; do ln -s /root/sys161/tools/bin/$i /root/sys161/bin/cs350-`echo $i | cut -d- -f4-`; done' \
    && ln -s /root/sys161/tools/bin/bmake /root/sys161/bin/bmake

# install sys161 simulator
WORKDIR /root/archive/sys161-1.99.06
RUN ./configure --prefix=/root/sys161 mipseb \
    && make \
    && make install \
    && ln -s /root/sys161/share/examples/sys161/sys161.conf.sample /root/sys161/sys161.conf

# copy configuration script
COPY init.sh /root/

# create volume
VOLUME /root/cs350-os161

# set work dir
WORKDIR /root
