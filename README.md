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

### Related artifacts

1. [DockerHub](https://hub.docker.com/r/senzing/resolver)
1. [Helm Chart](https://github.com/Senzing/charts/tree/master/charts/resolver)

### Contents

1. [Expectations](#expectations)
    1. [Space](#space)
    1. [Time](#time)
    1. [Background knowledge](#background-knowledge)
1. [Preparation](#preparation)
    1. [Prerequisite software](#prerequisite-software)
    1. [Clone repository](#clone-repository)
    1. [Volumes](#volumes)
1. [Demonstrate using Command Line](#demonstrate-using-command-line)
    1. [Install](#install)
    1. [Run command](#run-command)
1. [Demonstrate using Docker](#demonstrate-using-docker)
    1. [Initialize Senzing](#initialize-senzing)
    1. [Configuration](#configuration)
    1. [Volumes](#volumes)
    1. [Docker network](#docker-network)
    1. [Docker user](#docker-user)
    1. [Run docker container](#run-docker-container)
1. [Demonstrate using Helm](#demonstrate-using-helm)
    1. [Prerequisite software for Helm demonstration](#prerequisite-software-for-helm-demonstration)
    1. [Create custom helm values files](#create-custom-helm-values-files)
    1. [Create custom kubernetes configuration files](#create-custom-kubernetes-configuration-files)
    1. [Create namespace](#create-namespace)
    1. [Create persistent volume](#create-persistent-volume)
    1. [Add helm repositories](#add-helm-repositories)
    1. [Deploy resolver](#deploy-resolver)
    1. [Install senzing-debug Helm chart](#install-senzing-debug-helm-chart)
    1. [Cleanup](#cleanup)
1. [Develop](#develop)
    1. [Prerequisite software](#prerequisite-software)
    1. [Clone repository](#clone-repository)
    1. [Build docker image for development](#build-docker-image-for-development)
1. [Examples](#examples)
1. [Errors](#errors)
1. [References](#references)

## Expectations

### Space

This repository and demonstration require 6 GB free disk space.

### Time

Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.

### Background knowledge

This repository assumes a working knowledge of:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/git.md)
1. [docker](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/docker.md)

## Demonstrate using Command Line

### Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. [senzingdata](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-senzing-data.md)
1. [senzingapi](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-senzing-api.md)

### Clone repository

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

1. Identify paths.
   Example:

    ```console
    export SENZING_VOLUME=/opt/my-senzing

    export SENZING_DATA_DIR=${SENZING_VOLUME}/data/1.0.0
    export SENZING_ETC_DIR=${SENZING_VOLUME}/etc
    export SENZING_G2_DIR=${SENZING_VOLUME}/g2
    export SENZING_VAR_DIR=${SENZING_VOLUME}/var
    ```

### Install

1. Install prerequisites:
    1. [Debian-based installation](docs/debian-based-installation.md) - For Ubuntu and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based)
    1. [RPM-based installation](docs/rpm-based-installation.md) - For Red Hat, CentOS, openSuse and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#RPM-based).


### Run commands

1. :pencil2: Run command.
   Note: **GIT_REPOSITORY_DIR** needs to be set.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    ./resolver.py file-input \
      --data-dir ${SENZING_DATA_DIR} /opt/senzing/data \
      --etc-dir ${SENZING_ETC_DIR} /etc/opt/senzing \
      --g2-dir ${SENZING_G2_DIR} /opt/senzing/g2 \
      --var-dir ${SENZING_VAR_DIR} /var/opt/senzing \
      --input-file test/test-data-1.json
    ```

### Run command

1. :pencil2: Run command.
   Note: **GIT_REPOSITORY_DIR** needs to be set.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    ./resolver.py service \
      --data-dir ${SENZING_DATA_DIR} /opt/senzing/data \
      --etc-dir ${SENZING_ETC_DIR} /etc/opt/senzing \
      --g2-dir ${SENZING_G2_DIR} /opt/senzing/g2 \
      --var-dir ${SENZING_VAR_DIR} /var/opt/senzing
    ```

## Demonstrate using Docker

### Initialize Senzing

1. If Senzing has not been initialized, visit
   "[How to initialize Senzing with Docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/initialize-senzing-with-docker.md)".

### Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_DATA_SOURCE](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_data_source)**
- **[SENZING_DATA_VERSION_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_data_version_dir)**
- **[SENZING_DATABASE_URL](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_database_url)**
- **[SENZING_DEBUG](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_debug)**
- **[SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_dir)**
- **[SENZING_ENTITY_TYPE](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_entity_type)**
- **[SENZING_ETC_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_etc_dir)**
- **[SENZING_G2_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_g2_dir)**
- **[SENZING_LOG_LEVEL](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_log_level)**
- **[SENZING_NETWORK](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_network)**
- **[SENZING_RUNAS_USER](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_runas_user)**
- **[SENZING_SLEEP_TIME](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_sleep_time)**
- **[SENZING_SUBCOMMAND](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_subcommand)**
- **[SENZING_VAR_DIR](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md#senzing_var_dir)**

1. To determine which configuration parameters are used for each `<subcommand>`, run:

    ```console
    ./resolver.py <subcommand> --help
    ```

### Volumes

:thinking:
"[How to initialize Senzing with Docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/initialize-senzing-with-docker.md)"
places files in different directories.
The following examples show how to identify each output directory.

1. **Example #1:**
   To mimic an actual RPM installation,
   identify directories for RPM output in this manner:

    ```console
    export SENZING_DATA_VERSION_DIR=/opt/senzing/data/1.0.0
    export SENZING_ETC_DIR=/etc/opt/senzing
    export SENZING_G2_DIR=/opt/senzing/g2
    export SENZING_VAR_DIR=/var/opt/senzing
    ```

1. :pencil2: **Example #2:**
   If Senzing directories were put in alternative directories,
   set environment variables to reflect where the directories were placed.
   Example:

    ```console
    export SENZING_VOLUME=/opt/my-senzing

    export SENZING_DATA_VERSION_DIR=${SENZING_VOLUME}/data/1.0.0
    export SENZING_ETC_DIR=${SENZING_VOLUME}/etc
    export SENZING_G2_DIR=${SENZING_VOLUME}/g2
    export SENZING_VAR_DIR=${SENZING_VOLUME}/var
    ```

1. :thinking: If internal database is used, permissions may need to be changed in `/var/opt/senzing`.
   Example:

    ```console
    sudo chmod -R 777 ${SENZING_VAR_DIR}
    ```

### Docker network

:thinking: **Optional:**  Use if docker container is part of a docker network.

1. List docker networks.
   Example:

    ```console
    sudo docker network ls
    ```

1. :pencil2: Specify docker network.
   Choose value from NAME column of `docker network ls`.
   Example:

    ```console
    export SENZING_NETWORK=*nameofthe_network*
    ```

1. Construct parameter for `docker run`.
   Example:

    ```console
    export SENZING_NETWORK_PARAMETER="--net ${SENZING_NETWORK}"
    ```

### Docker user

:thinking: **Optional:**  The docker container runs as "USER 1001".
Use if a different userid is required.

1. :pencil2: Identify user.
   User "0" is root.
   Example:

    ```console
    export SENZING_RUNAS_USER="0"
    ```

1. Construct parameter for `docker run`.
   Example:

    ```console
    export SENZING_RUNAS_USER_PARAMETER="--user ${SENZING_RUNAS_USER}"
    ```

### Run docker container

#### Option #1

This Option starts a micro-service supporting HTTP requests.

1. Run the docker container.
   Example:

    ```console
    sudo docker run \
      ${SENZING_RUNAS_USER_PARAMETER} \
      ${SENZING_NETWORK_PARAMETER} \
      --interactive \
      --publish 8252:8252 \
      --rm \
      --tty \
      --volume ${SENZING_DATA_VERSION_DIR}:/opt/senzing/data \
      --volume ${SENZING_ETC_DIR}:/etc/opt/senzing \
      --volume ${SENZING_G2_DIR}:/opt/senzing/g2 \
      --volume ${SENZING_VAR_DIR}:/var/opt/senzing \
      senzing/resolver
    ```

1. Test HTTP API.
   Note: **GIT_REPOSITORY_DIR** needs to be set.
   Example:

    ```console
    curl -X POST \
      --header "Content-Type: text/plain" \
      --data-binary @${GIT_REPOSITORY_DIR}/test/test-data-1.json \
      http://localhost:8252/resolve
    ```

#### Option #2

This Option uses file input and output.

1. :pencil2: Set environment variables.
   Example:

    ```console
    export DATA_DIR=${GIT_REPOSITORY_DIR}/test
    ```

1. Run the docker container.
   Example:

    ```console
    sudo docker run \
      ${SENZING_RUNAS_USER_PARAMETER} \
      ${SENZING_NETWORK_PARAMETER} \
      --rm \
      --volume ${DATA_DIR}:/data \
      --volume ${SENZING_DATA_VERSION_DIR}:/opt/senzing/data \
      --volume ${SENZING_ETC_DIR}:/etc/opt/senzing \
      --volume ${SENZING_G2_DIR}:/opt/senzing/g2 \
      --volume ${SENZING_VAR_DIR}:/var/opt/senzing \
      senzing/resolver file-input \
        --input-file  /data/test-data-1.json \
        --output-file /data/my-output.json
    ```

1. Output will be on workstation at ${DATA_DIR}/my-output.json

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
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

### Docker images

#### Senzing docker images

1. Accept End User License Agreement (EULA) for `store/senzing/senzing-package` docker image.
    1. Visit [HOWTO - Accept EULA](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/accept-eula.md#storesenzingsenzing-package-docker-image).

1. Pull images from DockerHub.
   Example:

    ```console
    sudo docker pull senzing/resolver:1.0.1
    sudo docker pull senzing/senzing-debug:1.1.0
    sudo docker pull store/senzing/senzing-package:1.10.19214
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
      "senzing/resolver:1.0.1" \
      "senzing/senzing-debug:1.1.0" \
      "store/senzing/senzing-package:1.10.19214" \
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
    export DOCKER_REGISTRY_URL=docker.io
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

    1. `${DOCKER_REGISTRY_SECRET}`
    1. `${DOCKER_REGISTRY_URL}`

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

    1. `${DEMO_NAMESPACE}`

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
      --name ${DEMO_PREFIX}-resolver \
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

### Install senzing-debug Helm chart

If debugging is needed, the `senzing/senzing-debug` chart will help with:

- Inspecting the `/opt/senzing` volume
- Debugging general issues

1. Install chart.  Example:

    ```console
    helm install \
      --name ${DEMO_PREFIX}-senzing-debug \
      --namespace ${DEMO_NAMESPACE} \
      --values ${GIT_REPOSITORY_DIR}/helm-values/senzing-debug.yaml \
       senzing/senzing-debug
    ```

1. Wait for pod to run.  Example:

    ```console
    kubectl get pods \
      --namespace ${DEMO_NAMESPACE} \
      --watch
    ```

1. In a separate terminal window, log into debug pod.

    :pencil2:  Set environment variables.  Example:

    ```console
    export DEMO_PREFIX=my
    export DEMO_NAMESPACE=${DEMO_PREFIX}-namespace
    ```

    Log into pod.  Example:

    ```console
    export DEBUG_POD_NAME=$(kubectl get pods \
      --namespace ${DEMO_NAMESPACE} \
      --output jsonpath="{.items[0].metadata.name}" \
      --selector "app.kubernetes.io/name=senzing-debug, \
                  app.kubernetes.io/instance=${DEMO_PREFIX}-senzing-debug" \
      )

    kubectl exec -it --namespace ${DEMO_NAMESPACE} ${DEBUG_POD_NAME} -- /bin/bash
    ```

### Cleanup

#### Delete everything in project

1. Example:

    ```console
    helm delete --purge ${DEMO_PREFIX}-senzing-debug
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

### Prerequisite software for development

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. [make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)

### Clone repository for development

For more information on environment variables,
see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/master/lists/environment-variables.md).

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

### Build docker image for development

1. **Option #1:** Using `docker` command and GitHub.

    ```console
    sudo docker build --tag senzing/resolver https://github.com/senzing/resolver.git
    ```

1. **Option #2:** Using `docker` command and local repository.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag senzing/resolver .
    ```

1. **Option #3:** Using `make` command.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo make docker-build
    ```

    Note: `sudo make docker-build-development-cache` can be used to create cached docker layers.

## Examples

## Errors

1. See [docs/errors.md](docs/errors.md).

## References
