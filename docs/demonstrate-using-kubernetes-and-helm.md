# Demonstrate using Kubernetes and Helm

This demonstrations uses
[minikube]
to demonstrate installing and using the Senzing Resolver in a Kubernetes environment.

## Prerequisite software for Helm demonstration

1. [minikube]
1. [kubectl]
1. [Helm 3]

## Clone repository for Helm demonstration

The Git repository has files that will be used in the `helm install --values` parameter.

1. Using these environment variable values:

   ```console
   export GIT_ACCOUNT=senzing
   export GIT_REPOSITORY=resolver
   export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
   export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
   ```

1. Follow steps in [clone-repository] to install the Git repository.

## Create artifact directory

1. :pencil2: Create a unique prefix.
   This will be used in a local directory name
   as well as a prefix to Kubernetes object.

   :warning: Because it's used in Kubernetes resource names,
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

## Start minikube cluster

Using [Get Started with Bitnami Charts using Minikube]
as a guide, start a minikube cluster.

1. Start cluster using
   [minikube start].
   Example:

   ```console
   minikube start --cpus 4 --memory 8192 --disk-size=50g
   ```

## View minikube cluster

:thinking: **Optional:** View the minikube cluster using the [dashboard].

1. Run command in a new terminal using [minikube dashboard].
   Example:

   ```console
   minikube dashboard
   ```

## Set environment variables

1. Set environment variables listed in "[Clone repository]".

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
   ```

## Identify Docker registry

:thinking: There are 3 options when it comes to using a docker registry. Choose one:

1. [Use public registry]
1. [Use private registry]
1. [Use minikube registry]

### Use public registry

**Method #1:** Pulls docker images from public internet registry.

1. Use the default public `docker.io` registry which pulls images from
   [hub.docker.com].
   Example:

   ```console
   export DOCKER_REGISTRY_URL=docker.io
   export DOCKER_REGISTRY_SECRET=${DOCKER_REGISTRY_URL}-secret
   ```

### Use private registry

**Method #2:** Pulls docker images from a private registry.

1. :pencil2: Specify a private registry.
   Example:

   ```console
   export DOCKER_REGISTRY_URL=my.example.com:5000
   export DOCKER_REGISTRY_SECRET=${DOCKER_REGISTRY_URL}-secret
   export SENZING_SUDO=sudo
   ${GIT_REPOSITORY_DIR}/bin/docker-pull-tag-and-push.sh docker-images
   ```

### Use minikube registry

**Method #3:** Pulls docker images from minikube's registry.

1. Use minikube's docker registry using [minikube addons enable] and [minikube image load].
   Example:

   ```console
   minikube addons enable registry
   export DOCKER_REGISTRY_URL=docker.io
   export DOCKER_REGISTRY_SECRET=${DOCKER_REGISTRY_URL}-secret
   ${GIT_REPOSITORY_DIR}/bin/populate-minikube-registry.sh docker-images
   ```

## Create custom helm values files

For final customization of the Helm Charts,
various files need to be created for use in the
`--values` parameter of `helm install`.

:thinking: In this step, Helm template files are populated with actual values.
There are two methods of accomplishing this.
Only one method needs to be performed.

1. **Method #1:** Helm template files are instantiated with actual values
   into `${HELM_VALUES_DIR}` directory by using
   [make-helm-values-files.sh].

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

## Create custom kubernetes configuration files

Create Kubernetes manifest files for use with `kubectl create`.

:thinking: In this step, Kubernetes template files are populated with actual values.
There are two methods of accomplishing this.
Only one method needs to be performed.

1. **Method #1:** Kubernetes manifest files are instantiated with actual values
   into `{KUBERNETES_DIR}` directory by using
   [make-kubernetes-manifest-files.sh].
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

## Save environment variables

Environment variables will be needed in new terminal windows using [save-environment-variables.sh].

1. Save environment variables into a file that can be sourced.
   Example:

   ```console
   ${GIT_REPOSITORY_DIR}/bin/save-environment-variables.sh
   ```

## Create namespace

A new [Kubernetes namespace] is created to isolate this demonstration from other
applications running on Kubernetes.

1. Create Kubernetes namespace using [kubectl create].
   Example:

   ```console
   kubectl create -f ${KUBERNETES_DIR}/namespace.yaml
   ```

1. :thinking: **Optional:**
   Review namespaces using
   [kubectl get].
   Example:

   ```console
   kubectl get namespaces
   ```

## Add Helm repositories

1. Add Senzing repository using [helm repo add].
   Example:

   ```console
   helm repo add senzing https://hub.senzing.com/charts/
   ```

1. Update repositories using [helm repo update].
   Example:

   ```console
   helm repo update
   ```

1. :thinking: **Optional:** Review repositories using [helm repo list].
   Example:

   ```console
   helm repo list
   ```

## Install resolver Helm chart

This deployment launches the [resolver].

1. Install [senzing/senzing-resolver] chart using [helm install].
   Example:

   ```console
   helm install \
     ${DEMO_PREFIX}-senzing-resolver \
     senzing/senzing-resolver \
     --namespace ${DEMO_NAMESPACE} \
     --values ${HELM_VALUES_DIR}/senzing-resolver.yaml \
     --version ${SENZING_HELM_VERSION_SENZING_RESOLVER:-""}
   ```

1. Wait for pods to run using [kubectl get].
   Example:

   ```console
   kubectl get pods \
     --namespace ${DEMO_NAMESPACE} \
     --watch
   ```

## Port forward senzing-resolver service

1. In a separate terminal window, port forward to local machine using [kubectl port-forward].
   Example:

   :pencil2: Set environment variables. Example:

   ```console
   export DEMO_PREFIX=my
   export DEMO_NAMESPACE=${DEMO_PREFIX}-namespace
   ```

   Port forward. Example:

   ```console
   kubectl port-forward \
     --address 0.0.0.0 \
     --namespace ${DEMO_NAMESPACE} \
     svc/${DEMO_PREFIX}-senzing-resolver 8252:80
   ```

1. Test HTTP API. Once service has started, try the [HTTP requests].

## Cleanup

### Delete everything in Kubernetes

Delete Kubernetes artifacts using [helm uninstall], [helm repo remove], and
[kubectl delete].

1. Example:

   ```console
   helm uninstall --namespace ${DEMO_NAMESPACE} ${DEMO_PREFIX}-senzing-resolver
   helm repo remove senzing
   kubectl delete -f ${KUBERNETES_DIR}/namespace.yaml
   ```

### Delete minikube cluster

Delete minikube artifacts using [minikube stop] and [minikube delete]

1. Example:

   ```console
   minikube stop
   minikube delete
   ```

[Clone repository]: development.md#clone-repository
[clone-repository]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/clone-repository.md
[dashboard]: https://minikube.sigs.k8s.io/docs/handbook/dashboard/
[Get Started with Bitnami Charts using Minikube]: https://docs.bitnami.com/kubernetes/get-started-kubernetes/#overview
[Helm 3]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/helm.md
[helm install]: https://helm.sh/docs/helm/helm_install/
[helm repo add]: https://helm.sh/docs/helm/helm_repo_add/
[helm repo list]: https://helm.sh/docs/helm/helm_repo_list/
[helm repo remove]: https://helm.sh/docs/helm/helm_repo_remove/
[helm repo update]: https://helm.sh/docs/helm/helm_repo_update/
[helm uninstall]: https://helm.sh/docs/helm/helm_uninstall/
[HTTP requests]: docs/examples.md#http-requests
[hub.docker.com]: https://hub.docker.com/
[kubectl create]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create
[kubectl delete]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete
[kubectl get]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get
[kubectl port-forward]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#port-forward
[kubectl]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/kubectl.md
[Kubernetes namespace]: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
[make-helm-values-files.sh]: ../../bin/make-helm-values-files.sh
[make-kubernetes-manifest-files.sh]: ../../bin/make-kubernetes-manifest-files.sh
[minikube addons enable]: https://minikube.sigs.k8s.io/docs/commands/addons/#minikube-addons-enable
[minikube dashboard]: https://minikube.sigs.k8s.io/docs/commands/dashboard/
[minikube delete]: https://minikube.sigs.k8s.io/docs/commands/delete/
[minikube image load]: https://minikube.sigs.k8s.io/docs/commands/image/#minikube-image-load
[minikube start]: https://minikube.sigs.k8s.io/docs/commands/start/
[minikube stop]: https://minikube.sigs.k8s.io/docs/commands/stop/
[minikube]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/minikube.md
[resolver]: https://github.com/senzing-garage/resolver
[save-environment-variables.sh]: ../../bin/save-environment-variables.sh
[senzing/senzing-resolver]: https://github.com/senzing-garage/charts/tree/main/charts/senzing-resolver
[Use minikube registry]: #use-minikube-registry
[Use private registry]: #use-private-registry
[Use public registry]: #use-public-registry
