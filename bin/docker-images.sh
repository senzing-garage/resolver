#!/usr/bin/env bash

# List all of the docker images to be installed into the minikube registry.

export DOCKER_IMAGES=(
    "senzing/resolver:${SENZING_DOCKER_IMAGE_VERSION_RESOLVER:-latest}"
)
