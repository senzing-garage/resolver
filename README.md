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
1. [Demonstrate using Helm](#demonstrate-using-helm)
    1. [Prerequisite software for Helm demonstration](#prerequisite-software-for-helm-demonstration)
    1. [Clone repository for Helm demonstration](#clone-repository-for-helm-demonstration)
    1. [Docker images](#docker-images)
    1. [Create custom helm values files](#create-custom-helm-values-files)
    1. [Create custom kubernetes configuration files](#create-custom-kubernetes-configuration-files)
    1. [Create namespace](#create-namespace)
    1. [Create persistent volume](#create-persistent-volume)
    1. [Add helm repositories](#add-helm-repositories)
    1. [Deploy Senzing_API.tgz package](#deploy-Senzing_API.tgz-package)
    1. [Deploy resolver](#deploy-resolver)
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

### Run command

1. Run command.
   Note: **GIT_REPOSITORY_DIR** needs to be set.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    ./resolver.py file-input --input-file test/test-data-1.json
    ```

## Demonstrate using Docker

### Create SENZING_DIR

1. If `/opt/senzing` directory is not on local system, visit
   [HOWTO - Create SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md).

### Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_DATA_SOURCE](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_data_source)**
- **[SENZING_DATABASE_URL](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_database_url)**
- **[SENZING_DEBUG](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_debug)**
- **[SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_dir)**
- **[SENZING_ENTITY_TYPE](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_entity_type)**
- **[SENZING_LOG_LEVEL](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_log_level)**
- **[SENZING_SLEEP_TIME](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_sleep_time)**
- **[SENZING_SUBCOMMAND](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_subcommand)**

1. To determine which configuration parameters are used for each `<subcommand>`, run:

    ```console
    ./resolver.py <subcommand> --help
    ```

### Run docker container

#### Option #1

This Option starts a micro-service supporting HTTP requests.

1. :pencil2: Set environment variables.
   Example:

    ```console
    export SENZING_DIR=/opt/senzing
    ```

1. Run the docker container.
   Example:

    ```console
    sudo docker run \
      --interactive \
      --publish 5001:5000 \
      --rm \
      --tty \
      --volume ${SENZING_DIR}:/opt/senzing \
      senzing/resolver
    ```

1. Test HTTP API.
   Note: **GIT_REPOSITORY_DIR** needs to be set.
   Example:

    ```console
    curl -X POST \
      --header "Content-Type: text/plain" \
      --data-binary @${GIT_REPOSITORY_DIR}/test/test-data-1.json \
      http://localhost:5001/resolve
    ```

#### Option #2

This Option uses file input and output.

1. :pencil2: Set environment variables.
   Example:

    ```console
    export SENZING_DIR=/opt/senzing
    export DATA_DIR=${GIT_REPOSITORY_DIR}/test
    ```

1. Run the docker container.
   Example:

    ```console
    sudo docker run \
      --rm \
      --volume ${SENZING_DIR}:/opt/senzing \
      --volume ${DATA_DIR}:/data \
      senzing/resolver file-input \
        --input-file  /data/test-data-1.json \
        --output-file /data/my-output.json
    ```

    Output will be on workstation at ${DATA_DIR}/my-output.json

## Demonstrate using Helm

### Prerequisite software for Helm demonstration

#### kubectl

1. [Install kubectl](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-kubectl.md).

#### minikube cluster

1. [Install minikube](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-minikube.md).
1. [Start cluster](https://docs.bitnami.com/kubernetes/get-started-kubernetes/#overview)

    ```console
    minikube start --cpus 4 --memory 8192
    ```

    Alternative:

    ```console
    minikube start --cpus 4 --memory 8192 --vm-driver kvm2
    ```

#### Helm/Tiller

1. [Install Helm](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-helm.md) on your local workstation.
1. [Install Tiller](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-tiller.md) in the minikube cluster.

### Clone repository for Helm demonstration

The Git repository has files that will be used in the `helm install --values` parameter.

1. Using these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

1. After the Git repository has been cloned, be sure the following environment variables are set:

    ```console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

### Docker images

#### Senzing docker images

1. Accept End User License Agreement (EULA) for `store/senzing/senzing-package` docker image.
    1. Visit [HOWTO - Accept EULA](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/accept-eula.md#storesenzingsenzing-package-docker-image).

1. Pull images from DockerHub.
   Example:

    ```console
    sudo docker pull store/senzing/senzing-package:1.10.19198
    sudo docker pull senzing/resolver:1.0.0
    ```

#### Docker registry

1. If you need to create a private docker registry, see
       [HOWTO - Install docker registry server](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker-registry-server.md).

1. :pencil2: Set environment variables.
   Example:

    ```console
    export DOCKER_REGISTRY_URL=my.docker-registry.com:5000
    ```

1. Add Senzing docker images to private docker registry.
   Example:

    ```console
    export DOCKER_IMAGE_NAMES=( \
      "store/senzing/senzing-package:1.10.19198" \
      "senzing/resolver:1.0.0" \
    )

    for DOCKER_IMAGE_NAME in ${DOCKER_IMAGE_NAMES[@]};\
    do \
      sudo docker tag  ${DOCKER_IMAGE_NAME} ${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}; \
      sudo docker push ${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}; \
      sudo docker rmi  ${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}; \
    done
    ```

### Create custom helm values files

1. :pencil2: Set environment variables.
   Example:

    ```console
    export DOCKER_REGISTRY_SECRET=my-registry-secret
    export DOCKER_REGISTRY_URL=my.docker-registry.com:5000
    ```

1. Option #1. Quick method using `envsubst`.
   Example:

    ```console
    export HELM_VALUES_DIR=${GIT_REPOSITORY_DIR}/helm-values
    mkdir -p ${HELM_VALUES_DIR}

    for file in ${GIT_REPOSITORY_DIR}/helm-values-templates/*.yaml; \
    do \
      envsubst < "${file}" > "${HELM_VALUES_DIR}/$(basename ${file})";
    done
    ```

1. Option #2. Copy and modify method.

    ```console
    export HELM_VALUES_DIR=${GIT_REPOSITORY_DIR}/helm-values
    mkdir -p ${HELM_VALUES_DIR}

    cp ${GIT_REPOSITORY_DIR}/helm-values-templates/* ${HELM_VALUES_DIR}
    ```

    :pencil2: Edit files in ${HELM_VALUES_DIR} replacing the following variables with actual values.

    1. `${DEMO_NAMESPACE}`

### Create custom kubernetes configuration files

1. :pencil2: Set environment variables.
   Example:

    ```console
    export DEMO_PREFIX=my
    export DEMO_NAMESPACE=${DEMO_PREFIX}-namespace
    ```

1. Option #1. Quick method using `envsubst`.
   Example:

    ```console
    export KUBERNETES_DIR=${GIT_REPOSITORY_DIR}/kubernetes
    mkdir -p ${KUBERNETES_DIR}

    for file in ${GIT_REPOSITORY_DIR}/kubernetes-templates/*; \
    do \
      envsubst < "${file}" > "${KUBERNETES_DIR}/$(basename ${file})";
    done
    ```

1. Option #2. Copy and modify method.

    ```console
    export KUBERNETES_DIR=${GIT_REPOSITORY_DIR}/kubernetes
    mkdir -p ${KUBERNETES_DIR}

    cp ${GIT_REPOSITORY_DIR}/kubernetes-templates/* ${KUBERNETES_DIR}
    ```

    :pencil2: Edit files in ${KUBERNETES_DIR} replacing the following variables with actual values.

    1. `${DOCKER_REGISTRY_SECRET}`
    1. `${DOCKER_REGISTRY_URL}`

### Create namespace

1. Create namespace.

    ```console
    kubectl create -f ${KUBERNETES_DIR}/namespace.yaml
    ```

1. Optional: Review namespaces.

    ```console
    kubectl get namespaces
    ```

### Create persistent volume

1. Create persistent volumes.
   Example:

    ```console
    kubectl create -f ${KUBERNETES_DIR}/persistent-volume-opt-senzing.yaml
    ```

1. Create persistent volume claims.
   Example:

    ```console
    kubectl create -f ${KUBERNETES_DIR}/persistent-volume-claim-opt-senzing.yaml
    ```

1. Optional: Review persistent volumes and claims.

    ```console
    kubectl get persistentvolumes \
      --namespace ${DEMO_NAMESPACE}

    kubectl get persistentvolumeClaims \
      --namespace ${DEMO_NAMESPACE}
    ```

### Add helm repositories

1. Add Senzing repository.
   Example:

    ```console
    helm repo add senzing https://senzing.github.io/charts/
    ```

1. Update repositories.

    ```console
    helm repo update
    ```

1. Optional: Review repositories

    ```console
    helm repo list
    ```

1. Reference: [helm repo](https://helm.sh/docs/helm/#helm-repo)

### Deploy Senzing_API.tgz package

This deployment initializes the Persistent Volume with Senzing code and data.

1. Install chart.
   Example:

    ```console
    helm install \
      --name ${DEMO_PREFIX}-senzing-package \
      --namespace ${DEMO_NAMESPACE} \
      --values ${HELM_VALUES_DIR}/senzing-package.yaml \
      senzing/senzing-package
    ```

1. Wait until Job has completed.
   Example:

    ```console
    kubectl get pods \
      --namespace ${DEMO_NAMESPACE} \
      --watch
    ```

1. Example of completion:

    ```console
    NAME                       READY   STATUS      RESTARTS   AGE
    my-senzing-package-8n2ql   0/1     Completed   0          2m44s
    ```

### Deploy resolver

This deployment launches the resolver.

1. Install chart.
   Example:

    ```console
    helm install \
      --name ${DEMO_PREFIX}-senzing-package \
      --namespace ${DEMO_NAMESPACE} \
      --values ${HELM_VALUES_DIR}/resolver.yaml \
      senzing/resolver
    ```

1. Wait for pods to run.  Example:

    ```console
    kubectl get pods \
      --namespace ${DEMO_NAMESPACE} \
      --watch
    ```

1. In a separate terminal window, port forward to local machine.

    :pencil2:  Set environment variables.  Example:

    ```console
    export DEMO_PREFIX=my
    export DEMO_NAMESPACE=${DEMO_PREFIX}-namespace
    ```

    Port forward.  Example:

    ```console
    kubectl port-forward \
      --address 0.0.0.0 \
      --namespace ${DEMO_NAMESPACE} \
      svc/${DEMO_PREFIX}-resolver 5001:5000
    ```

1. Test HTTP API.
   Note: **GIT_REPOSITORY_DIR** needs to be set.
   Example:

    ```console
    curl -X POST \
      --header "Content-Type: text/plain" \
      --data-binary @${GIT_REPOSITORY_DIR}/test/test-data-1.json \
      http://localhost:5001/resolve
    ```

### Cleanup

#### Delete everything in project

1. Example:

    ```console
    helm delete --purge ${DEMO_PREFIX}-resolver
    helm delete --purge ${DEMO_PREFIX}-senzing-package
    helm repo remove senzing
    kubectl delete -f ${KUBERNETES_DIR}/persistent-volume-claim-opt-senzing.yaml
    kubectl delete -f ${KUBERNETES_DIR}/persistent-volume-opt-senzing.yaml
    kubectl delete -f ${KUBERNETES_DIR}/namespace.yaml
    ```

#### Delete minikube cluster

1. Example:

    ```console
    minikube stop
    minikube delete
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
