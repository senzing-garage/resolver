
# Demonstrate using Command Line

## Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/git.md)
1. [senzingapi](https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/install-senzing-api.md)

## Clone repository

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/clone-repository.md) to install the Git repository.

## Install

1. Install prerequisites:
    1. [Debian-based installation](docs/debian-based-installation.md) - For Ubuntu and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based)
    1. [RPM-based installation](docs/rpm-based-installation.md) - For Red Hat, CentOS, openSuse and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#RPM-based).

## Run commands

1. Make sure the following environment variables are set.
   Example:

    ```console
    export LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:$LD_LIBRARY_PATH
    export PYTHONPATH=/opt/senzing/g2/python
    ```

1. View `file-input` subcommand parameters.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    ./resolver.py file-input --help
    ```

1. Run command for file input/output.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    ./resolver.py file-input \
      --input-file test/test-data-1.json \
      --output-file ${GIT_REPOSITORY_DIR}/resolver-output.json
    ```

1. Run command for starting HTTP API.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    ./resolver.py service
    ```

1. Test HTTP API.
   Once service has started, try the
   [HTTP requests](docs/examples.md#http-requests).
