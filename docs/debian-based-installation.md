# Debian-based installation

The following instructions are meant to be "copy-and-paste" to install and demonstrate.
If a step requires you to think and make a decision, it will be prefaced with :pencil2:.

The instructions have been tested against a bare
[ubuntu-18.04.1-server-amd64.iso](http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.1-server-amd64.iso)
image.

## Overview

1. [Prerequisite software](#prerequisite-software)
1. [Clone repository](#clone-repository)
1. [Set environment variables](#set-environment-variables)
1. [Install](#install)

## Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)

## Clone repository

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

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
    sudo xargs apt -y install < ${GIT_REPOSITORY_DIR}/src/apt-packages.txt
    ```

### PIP installs

1. Run:

    ```console
    pip3 install -r ${GIT_REPOSITORY_DIR}/requirements.txt
    ```

### Create SENZING_DIR

If you do not already have an `/opt/senzing` directory on your local system, visit
[HOWTO - Create SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md).
