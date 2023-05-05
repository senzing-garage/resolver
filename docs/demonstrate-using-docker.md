# Demonstrate using Docker

## As micro-service

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
   [HTTP requests](docs/examples.md#http-requests).

## As file input/output

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
