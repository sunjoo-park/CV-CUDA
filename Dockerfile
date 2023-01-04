# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Builds a Docker image capable of running the code in the book
FROM ubuntu:22.04
ARG USERNAME=nota
ARG TARGET_DIR=/usr/local
ARG CUDA_INSTALLER=cuda_11.7.0_515.43.04_linux.run
ARG CUDNN_TAR_BALL=cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz
ARG TensorRT_TAR_BALL=TensorRT-8.5.2.2.Linux.x86_64-gnu.cuda-11.8.cudnn8.6.tar.gz
WORKDIR /tmp
RUN apt update -y && apt install -y wget curl file libxml2-dev libssl-dev zlib1g-dev libbz2-dev liblzma-dev python3-dev build-essential

COPY ${CUDA_INSTALLER} .
COPY ${CUDNN_TAR_BALL} .
COPY ${TensorRT_TAR_BALL} .

RUN mkdir -p $TARGET_DIR
RUN chmod +x ${CUDA_INSTALLER}
ENV CUDA_ROOT=${TARGET_DIR}/cuda_11.7
RUN ./${CUDA_INSTALLER} --toolkit --toolkitpath=${CUDA_ROOT} --silent

ENV CUDNN_ROOT=${TARGET_DIR}/cudnn-8.6.0
RUN mkdir -p ${CUDNN_ROOT}
RUN ls -l
RUN apt install -y file && file ${CUDNN_TAR_BALL}} 
RUN apt install -y tar xz-utils
RUN rm -rfv ${CUDNN_TAR_BALL}}
RUN tar xJf ${CUDNN_TAR_BALL} -C ${CUDNN_ROOT} --strip-components=1

ENV TensorRT_ROOT=${TARGET_DIR}/TensorRT-8.5.2.2
RUN mkdir -p ${TensorRT_ROOT}
COPY ${TensorRT_TAR_BALL} .
RUN tar xzf ${TensorRT_TAR_BALL} -C ${TensorRT_ROOT} --strip-components=1

ENV  PATH=${CUDA_ROOT}/bin:$PATH
ENV  LD_LIBRARY_PATH=${CUDA_ROOT}/lib64:$LD_LIBRARY_PATH
ENV  LD_LIBRARY_PATH=${CUDNN_ROOT}/lib:$LD_LIBRARY_PATH
ENV  C_INCLUDE_PATH=${CUDNN_ROOT}/include:$C_INCLUDE_PATH
ENV  PATH=${TensorRT_ROOT}/bin:$PATH
ENV  LD_LIBRARY_PATH=${TensorRT_ROOT}/lib:$LD_LIBRARY_PATH

#RUN python3 -m pip install --upgrade apache-beam[gcp] cloudml-hypertune
#RUN mkdir -p /src/practical-ml-vision-book

# copy all the chapters that start with 01_* 02_* etc.

# Create the user
RUN useradd -s /bin/bash -m $USERNAME \
    && apt-get -y update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /workspace
