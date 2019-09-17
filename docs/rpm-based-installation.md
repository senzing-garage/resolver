# RPM-based installation

The following instructions are meant to be "copy-and-paste" to install and demonstrate.
If a step requires you to think and make a decision, it will be prefaced with :pencil2:.

The instructions have been tested against a bare
[CentOS-7-x86_64-Minimal-1810.iso](https://mirror.umd.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso)
image.

## Overview

1. [Set environment variables](#set-environment-variables)
1. [Install](#install)

## Set Environment variables

1. Synthesize environment variables.

    ```console
    export LD_LIBRARY_PATH=${SENZING_G2_DIR}/lib:${SENZING_G2_DIR}/lib/debian:$LD_LIBRARY_PATH
    export PYTHONPATH=${SENZING_G2_DIR}/python
    ```

## Install

### Yum installs

1. Run:

    ```console
    sudo xargs yum -y install < ${GIT_REPOSITORY_DIR}/src/yum-packages.txt
    ```

### PIP installs

1. Run:

    ```console
    pip3 install -r ${GIT_REPOSITORY_DIR}/requirements.txt
    ```
