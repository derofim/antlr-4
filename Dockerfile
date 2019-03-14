# The usual way of running this is as follows:
# docker run -v `pwd`:`pwd` -w `pwd` -u `id -u`:`id -g` <tagged-container-name> antlr4 <antlr options>
# Run a terminal in container
# sudo docker run  -it  --rm -e DISPLAY         -v /tmp/.X11-unix:/tmp/.X11-unix  my-docker-gcc

# see https://tomassetti.me/getting-started-antlr-cpp/

FROM ubuntu:18.04

MAINTAINER derofim

# https://askubuntu.com/a/1013396
# RUN export DEBIAN_FRONTEND=noninteractive
# Set it via ARG as this only is available during build:
ARG DEBIAN_FRONTEND=noninteractive

# how many cores to use for compilation
ARG BUILD_CORES=4

ARG version=4.7.2

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

ARG APT="apt-get -qq --no-install-recommends"

# https://www.peterbe.com/plog/set-ex
RUN set -ex

RUN $APT update

RUN $APT install -y --reinstall software-properties-common

RUN $APT install -y gnupg2 wget apt-utils

RUN $APT update

RUN $APT install -y \
            ca-certificates \
            software-properties-common \
            git \
            wget

RUN $APT update

RUN $APT install -y \
            make \
            git \
            curl \
            vim \
            vim-gnome \
            uuid-dev \
            unzip \
            pkgconf \
            python

RUN $APT install -y cmake

RUN $APT install -y \
            build-essential \
            clang-6.0 python-lldb-6.0 lldb-6.0 lld-6.0 llvm-6.0-dev \
            clang-tools-6.0 libclang-common-6.0-dev libclang-6.0-dev \
            libc++abi-dev libc++-dev libclang-common-6.0-dev libclang1-6.0 libclang-6.0-dev

RUN mkdir -p /usr/java

RUN $APT install -y default-jre
ENV JAVA_HOME $(readlink -f /usr/bin/javac | sed "s:bin/javac::")
RUN echo "JAVA_HOME=$JAVA_HOME"

# https://serverfault.com/a/143838
ENV JAVA_HOME $(readlink -f /usr/bin/java | sed "s:bin/java::")

RUN $APT install -y default-jdk
RUN echo "JDK_HOME=$JDK_HOME"

# Get jdk. -j -> junk cookies -k -> ignore certificates -L -> follow redirects -H [arg] -> headers
#RUN wget -O java.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie"
# https://stackoverflow.com/a/10959815/10904212
# https://www.osradar.com/installation-of-the-64-bit-jdk-on-any-linux-platforms/
# RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3a%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html; oraclelicense=accept-securebackup-cookie;" "https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz"
#RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz"
#
#RUN ls
#RUN tar xfz java.tar.gz -C /usr/java
#ENV JAVA_HOME /usr/java/jdk1.8.0_191

ENV PATH $PATH:$JAVA_HOME/bin
WORKDIR /usr/local/lib
RUN mkdir -p /usr/java/lib

RUN wget https://www.antlr.org/download/antlr-${version}-complete.jar -P /usr/local/lib

# antlr alias. usage:
# antlr4 -Dlanguage=Cpp <name-of-grammar>
# antlr4 -Dlanguage=Cpp -no-listener -visitor -o antlr4-runtime Scene.g4
# The -no-listener and -visitor options stop the generation of the listener (active by default) and activate the generation of the visitor. 
# RUN alias antlr4=java -jar /usr/local/lib/antlr-${version}-complete.jar
RUN echo '#!/bin/bash\njava -jar /usr/local/lib/antlr-${version}-complete.jar' > /usr/bin/antlr4
RUN chmod +x /usr/bin/antlr4

RUN ln -s /usr/local/lib/antlr-${version}-complete.jar /usr/local/lib/antlr4.jar
ENV ANTLR4_JAR /usr/local/lib/antlr-${version}-complete.jar
ENV ANTLR4_HOME /usr/local/lib
ENV PATH $PATH:/usr/local/lib

# antlr TestRig alias.
RUN echo '#!/bin/bash\njava org.antlr.v4.gui.TestRig' > /usr/bin/grun
ENV ANTLR4_GRUN /usr/bin/grun
RUN chmod +x /usr/bin/grun

RUN wget https://www.antlr.org/download/antlr4-cpp-runtime-${version}-source.zip -P /usr/local/lib
RUN yes | unzip -d antlr4-cpp-runtime /usr/local/lib/antlr4-cpp-runtime-*-source.zip
ENV ANTLR4_CPP_RUNTIME_HOME /usr/local/lib/antlr4-cpp-runtime
RUN cd antlr4-cpp-runtime && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j${BUILD_CORES} && make install
ENV CLASSPATH .:/usr/local/lib/antlr-${version}-complete.jar:$CLASSPATH

RUN LD_LIBRARY_PATH=/usr/local/lib && export LD_LIBRARY_PATH && ldconfig -v

# NOTE: you can also install https://marketplace.visualstudio.com/items?itemName=mike-lischke.vscode-antlr4