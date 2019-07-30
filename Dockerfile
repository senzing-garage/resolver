ARG BASE_IMAGE=senzing/senzing-base:1.1.0
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-07-29

LABEL Name="senzing/resolver" \
      Maintainer="support@senzing.com" \
      Version="1.1.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

# Copy files from repository.

COPY ./rootfs /
COPY ./resolver.py /app

# Make non-root container.

USER 1001

# Runtime execution.

WORKDIR /app
CMD ["/app/resolver.py"]
