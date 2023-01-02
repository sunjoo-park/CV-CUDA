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
FROM nvcr.io/nvidia/tensorrt:22.09-py3
ARG USERNAME=nota

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
