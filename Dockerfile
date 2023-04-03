ARG BASE_IMAGE=senzing/senzingapi-runtime:3.5.0

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS builder

ENV REFRESHED_AT=2023-04-03

LABEL Name="senzing/resolver" \
      Maintainer="support@senzing.com" \
      Version="3.0.6"

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt update \
 && apt -y install \
      curl \
      libaio1 \
      python3 \
      python3-dev \
      python3-pip \
      python3-venv \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment.

RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install packages via PIP.

COPY requirements.txt .
RUN pip3 install --upgrade pip \
 && pip3 install -r requirements.txt \
 && rm requirements.txt

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

# Create the runtime image.

FROM ${BASE_IMAGE} AS runner

ENV REFRESHED_AT=2023-04-03

LABEL Name="senzing/resolver" \
      Maintainer="support@senzing.com" \
      Version="3.0.6"

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt update \
 && apt -y install \
      libaio1 \
      libxml2 \
      python3 \
      python3-venv \
 && apt clean \
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
