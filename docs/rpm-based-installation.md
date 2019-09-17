# RPM-based installation

The following instructions are meant to be "copy-and-paste" to install and demonstrate.
If a step requires you to think and make a decision, it will be prefaced with :pencil2:.

The instructions have been tested against a bare
[CentOS-7-x86_64-Minimal-1810.iso](https://mirror.umd.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso)
image.

## Overview

1. [Prerequisite software](#prerequisite-software)
1. [Clone repository](#clone-repository)
1. [Set environment variables](#set-environment-variables)
1. [Install](#install)

## Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)
1. [docker-compose](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker-compose.md)
1. [senzingapi](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-senzing-api.md)

## Clone repository

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

### Volumes

:thinking: The output of `yum install senzingapi` places files in different directories.
Identify a folder for each output directory.

1. :pencil2: **Example #1:**
   To mimic an actual RPM installation,
   identify directories for RPM output in this manner:

    ```console
    export SENZING_DATA_DIR=/opt/senzing/data
    export SENZING_DATA_VERSION_DIR=${SENZING_DATA_DIR}/1.0.0
    export SENZING_ETC_DIR=/etc/opt/senzing
    export SENZING_G2_DIR=/opt/senzing/g2
    export SENZING_VAR_DIR=/var/opt/senzing
    ```

1. :pencil2: **Example #2:**
   Senzing directories can be put in alternative directories.
   Example:

    ```console
    export SENZING_VOLUME=/opt/my-senzing

    export SENZING_DATA_DIR=${SENZING_VOLUME}/data
    export SENZING_DATA_VERSION_DIR=${SENZING_DATA_DIR}/1.0.0
    export SENZING_ETC_DIR=${SENZING_VOLUME}/etc
    export SENZING_G2_DIR=${SENZING_VOLUME}/g2
    export SENZING_VAR_DIR=${SENZING_VOLUME}/var
    ```

## Set Environment variables

1. :pencil2: Set environment variables.

    ```console
    export SENZING_DIR=/opt/senzing
    ```

1. Synthesize environment variables.

    ```console
    export GIT_REPOSITORY_URL="https://github.com/${GIT_ACCOUNT}/${GIT_REPOSITORY}.git"
    export LD_LIBRARY_PATH=${SENZING_DIR}/g2/lib:${SENZING_DIR}/g2/lib/debian:$LD_LIBRARY_PATH
    export PYTHONPATH=${SENZING_DIR}/g2/python
    ```

## Install

### APT installs

1. Run:

    ```console
    sudo xargs yum -y install < ${GIT_REPOSITORY_DIR}/src/yum-packages.txt
    ```

### PIP installs

1. Run:

    ```console
    pip3 install -r ${GIT_REPOSITORY_DIR}/requirements.txt
    ```

### Create SENZING_DIR

If you do not already have an `/opt/senzing` directory on your local system, visit
[HOWTO - Create SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md).
