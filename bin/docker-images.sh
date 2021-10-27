#!/usr/bin/env bash

# List all of the docker images to be installed into the minikube registry.

export DOCKER_IMAGES=(
    "senzing/init-container:${SENZING_DOCKER_IMAGE_VERSION_INIT_CONTAINER:-latest}"
    "senzing/resolver:${SENZING_DOCKER_IMAGE_VERSION_RESOLVER:-latest}"
    "senzing/senzing-base:${SENZING_DOCKER_IMAGE_VERSION_SENZING_BASE:-latest}"
    "senzing/senzing-console:${SENZING_DOCKER_IMAGE_VERSION_SENZING_CONSOLE:-latest}"
    "senzing/yum:${SENZING_DOCKER_IMAGE_VERSION_YUM:-latest}"
)
