# resolver

## Synopsis

Performs resolution on a single set of input records.  There is no persistence of input records.

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

1. [Preamble](#preamble)
1. [Related artifacts](#related-artifacts)
1. [Expectations](#expectations)
1. [Demonstrate using Command Line](#demonstrate-using-command-line)
    1. [Prerequisite software](#prerequisite-software)
    1. [Clone repository](#clone-repository)
    1. [Install](#install)
    1. [Run commands](#run-commands)
1. [Demonstrate using Docker](#demonstrate-using-docker)
    1. [As micro-service](#as-micro-service)
    1. [As file input/output](#as-file-inputoutput)
1. [Demonstrate using Kubernetes and Helm](#demonstrate-using-kubernetes-and-helm)
    1. [Prerequisite software for Helm demonstration](#prerequisite-software-for-helm-demonstration)
    1. [Clone repository for Helm demonstration](#clone-repository-for-helm-demonstration)
    1. [Create artifact directory](#create-artifact-directory)
    1. [Start minikube cluster](#start-minikube-cluster)
    1. [View minikube cluster](#view-minikube-cluster)
    1. [Set environment variables](#set-environment-variables)
    1. [EULA](#eula)
    1. [Identify Docker registry](#identify-docker-registry)
    1. [Create custom helm values files](#create-custom-helm-values-files)
    1. [Create custom kubernetes configuration files](#create-custom-kubernetes-configuration-files)
    1. [Save environment variables](#save-environment-variables)
    1. [Create namespace](#create-namespace)
    1. [Create persistent volume](#create-persistent-volume)
    1. [Add Helm repositories](#add-helm-repositories)
    1. [Deploy Senzing](#deploy-senzing)
    1. [Install init-container Helm chart](#install-init-container-helm-chart)
    1. [Install resolver Helm chart](#install-resolver-helm-chart)
    1. [Port forward senzing-resolver service](#port-forward-senzing-resolver-service)
    1. [Cleanup](#cleanup)
1. [Develop](#develop)
    1. [Prerequisite software for development](#prerequisite-software-for-development)
    1. [Clone repository for development](#clone-repository-for-development)
    1. [Build docker image for development](#build-docker-image-for-development)
1. [Examples](#examples)
    1. [HTTP requests](#http-requests)
1. [Errors](#errors)
1. [References](#references)

## Preamble

At [Senzing](http://senzing.com),
we strive to create GitHub documentation in a
"[don't make me think](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/dont-make-me-think.md)" style.
For the most part, instructions are copy and paste.
Whenever thinking is needed, it's marked with a "thinking" icon :thinking:.
Whenever customization is needed, it's marked with a "pencil" icon :pencil2:.
If the instructions are not clear, please let us know by opening a new
[Documentation issue](https://github.com/Senzing/resolver/issues/new?assignees=&labels=&template=documentation_request.md)
describing where we can improve.   Now on with the show...

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps you'll need to make some choices.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Related artifacts

1. [DockerHub](https://hub.docker.com/r/senzing/resolver)
1. [Helm Chart](https://github.com/Senzing/charts/tree/main/charts/resolver)

## Expectations

- **Space:** This repository and demonstration require 20 GB free disk space.
- **Time:** Budget 4 hours to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/docker.md)
  - [Kubernetes](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/kubernetes.md)
  - [Helm](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/helm.md)

## Demonstrate using Command Line

### Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-git.md)
1. [senzingapi](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-senzing-api.md)

### Clone repository

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/clone-repository.md) to install the Git repository.

### Install

1. Install prerequisites:
    1. [Debian-based installation](docs/debian-based-installation.md) - For Ubuntu and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based)
    1. [RPM-based installation](docs/rpm-based-installation.md) - For Red Hat, CentOS, openSuse and [others](https://en.wikipedia.org/wiki/List_of_Linux_distributions#RPM-based).

### Run commands

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
   [HTTP requests](#http-requests).

## Demonstrate using Docker

### As micro-service

This option starts a micro-service supporting HTTP requests.

1. Run the docker container.
   Example:

    ```console
    curl -X GET \
      --output ${SENZING_VOLUME}/docker-versions-stable.sh \
      https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/docker-versions-stable.sh
    source ${SENZING_VOLUME}/docker-versions-stable.sh

    docker run \
      --publish 8252:8252 \
      --rm \
      senzing/resolver:${SENZING_DOCKER_IMAGE_VERSION_RESOLVER:-latest}
    ```

1. Test HTTP API.
   Once service has started, try the
   [HTTP requests](#http-requests).

### As file input/output

This Option uses file input and output.

1. :pencil2: Set environment variables.
   Example:

    ```console
    export DATA_DIR=${GIT_REPOSITORY_DIR}/test
    ```

1. Run docker container.
   Example:

    ```console
    curl -X GET \
      --output ${SENZING_VOLUME}/docker-versions-stable.sh \
      https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/docker-versions-stable.sh
    source ${SENZING_VOLUME}/docker-versions-stable.sh

    docker run \
      --rm \
      --volume ${DATA_DIR}:/data \
      senzing/resolver:${SENZING_DOCKER_IMAGE_VERSION_RESOLVER:-latest} file-input \
        --input-file  /data/test-data-1.json \
        --output-file /data/my-output.json
    ```

1. Output will be on workstation at ${DATA_DIR}/my-output.json

## Demonstrate using Kubernetes and Helm

This demonstrations uses
[minikube](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-minikube.md)
to demonstrate installing and using the Senzing Resolver in a Kubernetes environment.

### Prerequisite software for Helm demonstration

1. [minikube](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-minikube.md)
1. [kubectl](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-kubectl.md)
1. [Helm 3](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-helm.md)

### Clone repository for Helm demonstration

The Git repository has files that will be used in the `helm install --values` parameter.

1. Using these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/clone-repository.md) to install the Git repository.

### Create artifact directory

1. :pencil2: Create a unique prefix.
   This will be used in a local directory name
   as well as a prefix to Kubernetes object.

   :warning:  Because it's used in Kubernetes resource names,
   it must be all lowercase.

   Example:

    ```console
    export DEMO_PREFIX=my
    ```

1. Make a directory for the demo.
   Example:

    ```console
    export SENZING_DEMO_DIR=~/senzing-resolver-${DEMO_PREFIX}
    mkdir -p ${SENZING_DEMO_DIR}
    ```

### Start minikube cluster

Using [Get Started with Bitnami Charts using Minikube](https://docs.bitnami.com/kubernetes/get-started-kubernetes/#overview)
as a guide, start a minikube cluster.

1. Start cluster using
   [minikube start](https://minikube.sigs.k8s.io/docs/commands/start/).
   Example:

    ```console
    minikube start --cpus 4 --memory 8192 --disk-size=50g
    ```

### View minikube cluster

:thinking: **Optional:** View the minikube cluster using the
[dashboard](https://minikube.sigs.k8s.io/docs/handbook/dashboard/).

1. Run command in a new terminal using
   [minikube dashboard](https://minikube.sigs.k8s.io/docs/commands/dashboard/).
   Example:

    ```console
    minikube dashboard
    ```

### Set environment variables

1. Set environment variables listed in "[Clone repository](#clone-repository)".

1. Synthesize environment variables.
   Example:

    ```console
    export DEMO_NAMESPACE=${DEMO_PREFIX}-namespace
    ```

1. Retrieve stable Docker image versions, Helm Chart versions, and Senzing versions and set their environment variables.
   Example:

    ```console
    curl -X GET \
        --output ${SENZING_DEMO_DIR}/docker-versions-stable.sh \
        https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/docker-versions-stable.sh
    source ${SENZING_DEMO_DIR}/docker-versions-stable.sh

    curl -X GET \
        --output ${SENZING_DEMO_DIR}/helm-versions-stable.sh \
        https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/helm-versions-stable.sh
    source ${SENZING_DEMO_DIR}/helm-versions-stable.sh

    curl -X GET \
        --output ${SENZING_DEMO_DIR}/senzing-versions-stable.sh \
        https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/senzing-versions-stable.sh
    source ${SENZING_DEMO_DIR}/senzing-versions-stable.sh
    ```

### EULA

To use the Senzing code, you must agree to the End User License Agreement (EULA).

1. :warning:
   To use the Senzing code, you must agree to the End User License Agreement (EULA).
   This step is intentionally tricky and not simply copy/paste.
   This ensures that you make a conscious effort to accept the EULA.
   Example:

    <pre>export SENZING_ACCEPT_EULA="&lt;the value from <a href="https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md#senzing_accept_eula">this link</a>&gt;"</pre>

### Create senzing/installer docker image

A method of installing the Senzing binaries on the Kubernetes PV/PVC
is to make a Docker image that contains the contents of the Senzing `g2` and `data` folders.

1. Run the `docker build` command using
   [docker-build-senzing-installer.sh](../../bin/docker-build-senzing-installer.sh).
   **Note:**
   This will take a while as the Senzing binary packages will be downloaded.
   Example:

    ```console
    ${GIT_REPOSITORY_DIR}/bin/docker-build-senzing-installer.sh
    ```

### Identify Docker registry

:thinking: There are 3 options when it comes to using a docker registry.  Choose one:

1. [Use public registry](#use-public-registry)
1. [Use private registry](#use-private-registry)
1. [Use minikube registry](#use-minikube-registry)

#### Use public registry

**Method #1:** Pulls docker images from public internet registry.

1. Use the default public `docker.io` registry which pulls images from
   [hub.docker.com](https://hub.docker.com/).
   Example:

    ```console
    export DOCKER_REGISTRY_URL=docker.io
    export DOCKER_REGISTRY_SECRET=${DOCKER_REGISTRY_URL}-secret
    ```

#### Use private registry

**Method #2:** Pulls docker images from a private registry.

1. :pencil2: Specify a private registry.
   Example:

    ```console
    export DOCKER_REGISTRY_URL=my.example.com:5000
    export DOCKER_REGISTRY_SECRET=${DOCKER_REGISTRY_URL}-secret
    export SENZING_SUDO=sudo
    ${GIT_REPOSITORY_DIR}/bin/populate-private-registry.sh
    ```

#### Use minikube registry

**Method #3:** Pulls docker images from minikube's registry.

1. Use minikube's docker registry using
   [minkube addons enable](https://minikube.sigs.k8s.io/docs/commands/addons/#minikube-addons-enable) and
   [minikube image load](https://minikube.sigs.k8s.io/docs/commands/image/#minikube-image-load).
   Example:

    ```console
    minikube addons enable registry
    export DOCKER_REGISTRY_URL=docker.io
    export DOCKER_REGISTRY_SECRET=${DOCKER_REGISTRY_URL}-secret
    ${GIT_REPOSITORY_DIR}/bin/populate-minikube-registry.sh
    ```

### Create custom helm values files

For final customization of the Helm Charts,
various files need to be created for use in the
`--values` parameter of `helm install`.

:thinking: In this step, Helm template files are populated with actual values.
There are two methods of accomplishing this.
Only one method needs to be performed.

1. **Method #1:** Helm template files are instantiated with actual values
   into `${HELM_VALUES_DIR}` directory by using
   [make-helm-values-files.sh](../../bin/make-helm-values-files.sh).

    ```console
    export HELM_VALUES_DIR=${SENZING_DEMO_DIR}/helm-values
    ${GIT_REPOSITORY_DIR}/bin/make-helm-values-files.sh
    ```

1. **Method #2:** Copy and manually modify files method.
   Example:

    ```console
    export HELM_VALUES_DIR=${SENZING_DEMO_DIR}/helm-values
    mkdir -p ${HELM_VALUES_DIR}

    cp ${GIT_REPOSITORY_DIR}/helm-values-templates/* ${HELM_VALUES_DIR}
    ```

    :pencil2: Edit files in ${HELM_VALUES_DIR} replacing the following variables with actual values.

    1. `${DEMO_PREFIX}`
    1. `${DOCKER_REGISTRY_SECRET}`
    1. `${DOCKER_REGISTRY_URL}`
    1. `${SENZING_ACCEPT_EULA}`

1. :thinking: **Optional:**
   List newly generated files.
   Example:

    ```console
    ls ${HELM_VALUES_DIR}
    ```

### Create custom kubernetes configuration files

Create Kubernetes manifest files for use with `kubectl create`.

:thinking: In this step, Kubernetes template files are populated with actual values.
There are two methods of accomplishing this.
Only one method needs to be performed.

1. **Method #1:** Kubernetes manifest files are instantiated with actual values
   into `{KUBERNETES_DIR}` directory by using
   [make-kubernetes-manifest-files.sh](../../bin/make-kubernetes-manifest-files.sh).
   Example:

    ```console
    export KUBERNETES_DIR=${SENZING_DEMO_DIR}/kubernetes
    ${GIT_REPOSITORY_DIR}/bin/make-kubernetes-manifest-files.sh
    ```

1. **Method #2:** Copy and manually modify files method.
   Example:

    ```console
    export KUBERNETES_DIR=${SENZING_DEMO_DIR}/kubernetes
    mkdir -p ${KUBERNETES_DIR}

    cp ${GIT_REPOSITORY_DIR}/kubernetes-templates/* ${KUBERNETES_DIR}
    ```

    :pencil2: Edit files in ${KUBERNETES_DIR} replacing the following variables with actual values.

    1. `${DEMO_NAMESPACE}`

1. :thinking: **Optional:**
   List newly generated files.
   Example:

    ```console
    ls ${KUBERNETES_DIR}
    ```

### Save environment variables

Environment variables will be needed in new terminal windows using
[save-environment-variables.sh](../../bin/save-environment-variables.sh).

1. Save environment variables into a file that can be sourced.
   Example:

    ```console
    ${GIT_REPOSITORY_DIR}/bin/save-environment-variables.sh
    ```

### Create namespace

A new
[Kubernetes namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
is created to isolate this demonstration from other applications running on Kubernetes.

1. Create Kubernetes namespace using
   [kubectl create](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create).
   Example:

    ```console
    kubectl create -f ${KUBERNETES_DIR}/namespace.yaml
    ```

1. :thinking: **Optional:**
   Review namespaces using
   [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get).
   Example:

    ```console
    kubectl get namespaces
    ```

### Create persistent volume

:thinking: **Optional:**
These steps for creating Persistent Volumes (PV) and Persistent Volume Claims (PVC)
are for a demonstration environment.
They are not sufficient for a production environment.
If PVs and PVCs already exist, this step may be skipped.

1. Create persistent volumes using
   [kubectl create](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create).
   Example:

    ```console
    kubectl create -f ${KUBERNETES_DIR}/persistent-volume-senzing.yaml
    ```

1. Create persistent volume claims using
   [kubectl create](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create).
   Example:

    ```console
    kubectl create -f ${KUBERNETES_DIR}/persistent-volume-claim-senzing.yaml
    ```

1. :thinking: **Optional:**
   Review persistent volumes and claims using
   [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get).
   Example:

    ```console
    kubectl get persistentvolumes \
      --namespace ${DEMO_NAMESPACE}

    kubectl get persistentvolumeClaims \
      --namespace ${DEMO_NAMESPACE}
    ```

### Add Helm repositories

1. Add Senzing repository using
   [helm repo add](https://helm.sh/docs/helm/helm_repo_add/).
   Example:

    ```console
    helm repo add senzing https://hub.senzing.com/charts/
    ```

1. Update repositories using
   [helm repo update](https://helm.sh/docs/helm/helm_repo_update/).
   Example:

    ```console
    helm repo update
    ```

1. :thinking: **Optional:**
   Review repositories using
   [helm repo list](https://helm.sh/docs/helm/helm_repo_list/).
   Example:

    ```console
    helm repo list
    ```

### Deploy Senzing

This deployment initializes the Persistent Volume with Senzing code and data
at `/opt/senzing/g2` and `/opt/senzing/data`.
These paths are relative to inside the containers via PVC mounts.
The actual location on the PVC may vary.

This method uses a docker container to copy Senzing binaries that are "baked-in"
the container to mounted volumes.
This method requires:

1. The `senzing/installer` image built in the
   [Create senzing/installer docker image](#create-senzinginstaller-docker-image)
   step.
1. Registry choice of
   "[Use private registry](#use-private-registry)"
   or
   "[Use minikube registry](#use-minikube-registry)".
   That is, the image is not available on the public DockerHub registry.

Copy Senzing's `g2` and `data` directories onto the Persistent Volume Claim (PVC)
at `/opt/senzing/g2` and `/opt/senzing/data`.
These paths are relative to inside the containers via PVC mounts.
The actual location on the PVC may vary.

1. Log into `minikube` instance using
   [minikube ssh](https://minikube.sigs.k8s.io/docs/commands/ssh/).
   Example:

    ```console
    minikube ssh
    ```

1. In the `minikube` instance, create `/mnt/vda1/senzing`.
   Example:

    ```console
    sudo mkdir -p /mnt/vda1/senzing
    exit
    ```

1. Install
   [senzing/senzing-installer](https://github.com/Senzing/charts/tree/main/charts/senzing-installer)
   chart using
   [helm install](https://helm.sh/docs/helm/helm_install/).
   Example:

    ```console
    helm install \
      ${DEMO_PREFIX}-senzing-installer \
      senzing/senzing-installer \
      --namespace ${DEMO_NAMESPACE} \
      --values ${HELM_VALUES_DIR}/senzing-installer.yaml\
      --version ${SENZING_HELM_VERSION_SENZING_INSTALLER:-""}
    ```

1. Wait until Job has completed using
   [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get).
   Example:

    ```console
    kubectl get pods \
      --namespace ${DEMO_NAMESPACE} \
      --watch
    ```

1. Example of completion:

    ```console
    NAME                         READY   STATUS      RESTARTS   AGE
    my-senzing-installer-8n2ql   0/1     Completed   0          2m44s
    ```

### Install init-container Helm chart

The [init-container](https://github.com/Senzing/docker-init-container)
creates files from templates and initializes the G2 database.

1. Install
   [senzing/senzing-init-container](https://github.com/Senzing/charts/tree/main/charts/senzing-init-container)
   chart using
   [helm install](https://helm.sh/docs/helm/helm_install/).
   Example:

    ```console
    helm install \
      ${DEMO_PREFIX}-senzing-init-container \
      senzing/senzing-init-container \
      --namespace ${DEMO_NAMESPACE} \
      --values ${HELM_VALUES_DIR}/senzing-init-container.yaml \
      --version ${SENZING_HELM_VERSION_SENZING_INIT_CONTAINER:-""}
    ```

1. Wait for pod to complete
   [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get).
   Example:

    ```console
    kubectl get pods \
      --namespace ${DEMO_NAMESPACE} \
      --watch
    ```

### Install resolver Helm chart

This deployment launches the
[resolver](https://github.com/Senzing/resolver).

1. Install
   [senzing/senzing-resolver](https://github.com/Senzing/charts/tree/main/charts/senzing-resolver)
   chart using
   [helm install](https://helm.sh/docs/helm/helm_install/).
   Example:

    ```console
    helm install \
      ${DEMO_PREFIX}-senzing-resolver \
      senzing/senzing-resolver \
      --namespace ${DEMO_NAMESPACE} \
      --values ${HELM_VALUES_DIR}/senzing-resolver.yaml \
      --version ${SENZING_HELM_VERSION_SENZING_RESOLVER:-""}
    ```

1. Wait for pods to run using
   [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get).
   Example:

    ```console
    kubectl get pods \
      --namespace ${DEMO_NAMESPACE} \
      --watch
    ```

### Port forward senzing-resolver service

1. In a separate terminal window, port forward to local machine using
   [kubectl port-forward](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#port-forward).
   Example:

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
      svc/${DEMO_PREFIX}-senzing-resolver 8252:80
    ```

1. Test HTTP API.
   Once service has started, try the
   [HTTP requests](#http-requests).

### Cleanup

#### Delete everything in Kubernetes

Delete Kubernetes artifacts using
[helm uninstall](https://helm.sh/docs/helm/helm_uninstall/),
[helm repo remove](https://helm.sh/docs/helm/helm_repo_remove/), and
[kubectl delete](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete).

1. Example:

    ```console
    helm uninstall --namespace ${DEMO_NAMESPACE} ${DEMO_PREFIX}-senzing-resolver
    helm uninstall --namespace ${DEMO_NAMESPACE} ${DEMO_PREFIX}-senzing-init-container
    helm uninstall --namespace ${DEMO_NAMESPACE} ${DEMO_PREFIX}-senzing-installer
    helm repo remove senzing
    kubectl delete -f ${KUBERNETES_DIR}/persistent-volume-claim-senzing.yaml
    kubectl delete -f ${KUBERNETES_DIR}/persistent-volume-senzing.yaml
    kubectl delete -f ${KUBERNETES_DIR}/namespace.yaml
    ```

#### Delete minikube cluster

Delete minikube artifacts using
[minikube stop](https://minikube.sigs.k8s.io/docs/commands/stop/) and
[minikube delete](https://minikube.sigs.k8s.io/docs/commands/delete/)

1. Example:

    ```console
    minikube stop
    minikube delete
    ```

## Develop

### Prerequisite software for development

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-git.md)
1. [make](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-make.md)
1. [docker](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/install-docker.md)

### Clone repository for development

For more information on environment variables,
see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md).

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/clone-repository.md) to install the Git repository.

### Build docker image for development

1. **Option #1:** Using `docker` command and GitHub.

    ```console
    sudo docker build
      --tag senzing/resolver \
      https://github.com/senzing/resolver.git#main
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

### HTTP requests

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=resolver
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

1. Test HTTP API.
   Example:

    ```console
    curl -X POST \
      --header "Content-Type: text/plain" \
      --data-binary @${GIT_REPOSITORY_DIR}/test/test-data-1.json \
      http://localhost:8252/resolve
    ```

1. Test HTTP API with JSON.
   Example:

    ```console
    curl -X POST \
      --header "Content-Type: text/plain" \
      --data-binary @${GIT_REPOSITORY_DIR}/test/test-data-1.json \
      http://localhost:8252/resolve?withJson=true
    ```

1. Test HTTP API with Features.
   Example:

    ```console
    curl -X POST \
      --header "Content-Type: text/plain" \
      --data-binary @${GIT_REPOSITORY_DIR}/test/test-data-1.json \
      http://localhost:8252/resolve?withFeatures=true
    ```

## Errors

1. See [docs/errors.md](docs/errors.md).

## References
