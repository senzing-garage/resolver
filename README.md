# resolver

## Overview

The [resolver.py](resolver.py) python script receives records, sends the records to Senzing, then queries Senzing for the resolved entities.
The `senzing/resolver` docker image is a wrapper for use in docker formations (e.g. docker-compose, kubernetes).

To see all of the subcommands, run:

```console
$ ./resolver.py
usage: resolver.py [-h]
                   {file-input,service,sleep,version,docker-acceptance-test}
                   ...

Resolve entities. For more information, see
https://github.com/Senzing/resolver

positional arguments:
  {file-input,service,sleep,version,docker-acceptance-test}
                        Subcommands (SENZING_SUBCOMMAND):
    file-input          File based input / output.
    service             Receive HTTP requests.
    sleep               Do nothing but sleep. For Docker testing.
    version             Print version of resolver.py.
    docker-acceptance-test
                        For Docker acceptance testing.

optional arguments:
  -h, --help            show this help message and exit
```

To see the options for a subcommand, run commands like:

```console
./resolver.py service --help
```

### Contents

1. [Expectations](#expectations)
    1. [Space](#space)
    1. [Time](#time)
    1. [Background knowledge](#background-knowledge)
1. [Demonstrate using Command Line](#demonstrate-using-command-line)
    1. [Install](#install)
1. [Demonstrate using Docker](#demonstrate-using-docker)
    1. [Create SENZING_DIR](#create-senzing_dir)
    1. [Configuration](#configuration)
    1. [Run docker container](#run-docker-container)
1. [Develop](#develop)
    1. [Prerequisite software](#prerequisite-software)
    1. [Clone repository](#clone-repository)
    1. [Build docker image for development](#build-docker-image-for-development)
1. [Examples](#examples)
1. [Errors](#errors)

## Expectations

### Space

This repository and demonstration require 6 GB free disk space.

### Time

Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.

### Background knowledge

This repository assumes a working knowledge of:

1. [Docker](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/docker.md)

## Demonstrate using Command Line

### Install

1. Install prerequisites:
    1. [Debian-based installation](docs/debian-based-installation.md) - For Ubuntu and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based)
    1. [RPM-based installation](docs/rpm-based-installation.md) - For Red Hat, CentOS, openSuse and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#RPM-based).
1. Install mock-data-generator
    1. See [github.com/Senzing/mock-data-generator](https://github.com/Senzing/mock-data-generator#using-command-line)

## Demonstrate using Docker

### Create SENZING_DIR

1. If `/opt/senzing` directory is not on local system, visit
   [HOWTO - Create SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md).

### Configuration

* **SENZING_DATA_SOURCE** -
  Default "DATA_SOURCE" value for incoming records.
  No default.
* **SENZING_DATABASE_URL** -
  Database URI in the form: `${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}`
  Default:  [internal SQLite database]
* **SENZING_DEBUG** -
  Enable debug information. Values: 0=no debug; 1=debug.
  Default: 0.
* **SENZING_DIR** -
  Path on the local system where
  [Senzing_API.tgz](https://s3.amazonaws.com/public-read-access/SenzingComDownloads/Senzing_API.tgz)
  has been extracted.
  See [Create SENZING_DIR](#create-senzing_dir).
  No default.
  Usually set to "/opt/senzing".
* **SENZING_ENTITY_TYPE** -
  Default "ENTITY_TYPE" value for incoming records.
  No default.
* **SENZING_LOG_LEVEL** -
  Level of logging. {notset, debug, info, warning, error, critical}.
  Default: info
* **SENZING_SLEEP_TIME** -
  Amount of time to sleep, in seconds for `resolver.py sleep` subcommand.
  Default: 600.
* **SENZING_SUBCOMMAND** -
  Identify the subcommand to be run. See `resolver.py --help` for complete list.


1. To determine which configuration parameters are use for each `<subcommand>`, run:

    ```console
    ./resolver.py <subcommand> --help
    ```

### Run docker container

1. :pencil2: Set environment variables.  Example:

    ```console
    export SENZING_DIR=/opt/senzing
    ```

1. Run the docker container.  Example:

    ```console
    sudo docker run \
      --interactive \
      --publish 5001:5000 \
      --rm \
      --tty \
      --volume ${SENZING_DIR}:/opt/senzing \
      senzing/resolver
    ```

1. Test HTTP API.  Example:

    ```console
    curl -X POST \
      --header "Content-Type: text/plain" \
      --data-binary @test/test-data-1.json \
      http://localhost:5001/resolve
    ```

## Develop

### Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. [make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)

### Clone repository

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

1. After the repository has been cloned, be sure the following are set:

    ```console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

### Build docker image for development

1. Option #1 - Using docker command and GitHub.

    ```console
    sudo docker build --tag senzing/resolver https://github.com/senzing/resolver.git
    ```

1. Option #2 - Using docker command and local repository.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag senzing/resolver .
    ```

1. Option #3 - Using make command.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo make docker-build
    ```

## Examples

## Errors

1. See [docs/errors.md](docs/errors.md).
