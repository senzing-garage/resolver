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
    export LD_LIBRARY_PATH=/opt/senzing/g2/lib:$LD_LIBRARY_PATH
    export PYTHONPATH=/opt/senzing/g2/python
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
    sudo pip3 install -r ${GIT_REPOSITORY_DIR}/requirements.txt
    ```

## Configure

1. Get configuration tool.
   Example:

    ```console
    curl -X GET \
      --output ~/init-container.py \
      https://raw.githubusercontent.com/Senzing/docker-init-container/master/init-container.py
    ```

1. Make `init-container.py` executable.
   Example:

    ```console
    chmod +x ~/init-container.py
    ```

1. Configure Senzing for use.
   Example:

    ```console
    sudo \
      LD_LIBRARY_PATH=${LD_LIBRARY_PATH} \
      PYTHONPATH=${PYTHONPATH} \
      ~/init-container.py initialize
    ```

1. Permit `/var/opt/senzing` for use by current user.
   Example:

    ```console
    sudo chown $(id -u):$(id -g) -R /var/opt/senzing
    ```
