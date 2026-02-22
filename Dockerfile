ARG BASE_IMAGE=senzing/senzingapi-runtime:3.13.0@sha256:c9c3502b35fbcc30d3cdbe3597392f964c7a15db52736dac938d28916d121f70

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS builder

ENV REFRESHED_AT=2026-01-16

# Run as "root" for system installation.

USER root

# Install packages via apt-get.

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
  curl \
  libaio1t64 \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment.

RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

COPY . /git-repository
WORKDIR /git-repository

# Install packages via PIP.

RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install .

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

# Create the runtime image.

FROM ${BASE_IMAGE} AS runner

ENV REFRESHED_AT=2026-01-16

LABEL Name="senzing/resolver" \
  Maintainer="support@senzing.com" \
  Version="3.0.10"

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
  libaio1t64 \
  libxml2 \
  python3 \
  python3-venv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Make directory that resolver.py can use.

RUN mkdir /var/opt/senzing-internal \
  && chown 1001 /var/opt/senzing-internal

# The port for the Flask is 5000.

EXPOSE 5000

# Copy files from repository.

COPY ./rootfs /
COPY ./resolver.py /app/

# Copy python virtual environment from the builder image.

COPY --from=builder /app/venv /app/venv

# Make non-root container.

USER 1001

# Activate virtual environment.

ENV VIRTUAL_ENV=/app/venv
ENV PATH="/app/venv/bin:${PATH}"

# Runtime environment variables.

ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin
ENV PYTHONPATH=/opt/senzing/g2/sdk/python
ENV PYTHONUNBUFFERED=1
ENV SENZING_DOCKER_LAUNCHED=true

# Runtime execution.

ENV SENZING_INTERNAL_DATABASE=/var/opt/senzing-internal/G2C.db

WORKDIR /app
ENTRYPOINT ["/app/resolver.py"]
CMD ["service"]
