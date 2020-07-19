FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
ENV PYTHON2=python
RUN pip3 install -I pyparsing==2.3.1
RUN pip3 install pyserial
RUN pip3 install rshell

RUN cd /root && git clone --recursive https://github.com/espressif/esp-idf.git
WORKDIR /root/esp-idf
RUN git checkout 4c81978a3e2220674a432a588292a4c860eef27b
RUN git submodule update --init --recursive
RUN ./install.sh

ENV ESPIDF=/root/esp-idf
ENV CROSS_COMPILE=/root/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin/xtensa-esp32-elf-
ENV PORT=/dev/ttyESP

WORKDIR /root

