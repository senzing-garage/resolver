ARG BASE_IMAGE=senzing/senzing-base:1.1.0
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-10-01

LABEL Name="senzing/resolver" \
      Maintainer="support@senzing.com" \
      Version="1.0.1"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via PIP.

RUN pip3 install \
    Flask==1.0.2 \
    flask_api

# The port for the Flask is 5000.

EXPOSE 5000

# Copy files from repository.

COPY ./rootfs /
COPY ./resolver.py /app

# Make directory that resolver.py can use.

RUN mkdir /var/opt/senzing \
 && chown 1001 /var/opt/senzing

# Make non-root container.

USER 1001

# Runtime execution.

ENV SENZING_INTERNAL_DATABASE=/var/opt/senzing/G2C.db

WORKDIR /app
ENTRYPOINT ["/app/resolver.py"]
CMD ["service"]
