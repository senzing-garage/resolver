# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2020-01-29

### Changed in 1.2.0

- Update to senzing/senzing-base:1.4.0

## [1.1.3] - 2020-01-28

### Changed in 1.1.3

- Return HTTP 400 upon error.  HTTP response contains error message.
- Separate `data_source` and `entity_type` processing

## [1.1.2] - 2019-12-30

### Changed in 1.1.2

- Improved scoping of `return_code` variable.

## [1.1.1] - 2019-11-25

### Changed in 1.1.1

- Use G2Engine.G2_ENTITY_BRIEF_FORMAT
- Update to docker image senzing/senzing-base:1.3.0

## [1.1.0] - 2019-10-26

### Changed in 1.1.0

- RPM based installation

## [1.0.1] - 2019-10-01

### Changed in 1.0.1

- "Prime the pump" when the docker containers comes up.
  This mitigates the lag seen on first access by initializing Senzing
  at `docker run` time rather than first HTTP request.

## [1.0.0] - 2019-08-15

### Added in 1.0.0

- Subcommands:
  - `resolver.py service`
  - `resolver.py file-input`
- Note: a "batch mode" datasource/entity-type configurator was attempted,  but was replaced with "on the fly" configuration.
  Reason: File-based iterators could not be reset, so two iterators would be needed -- potentially bloating memory.
  The use of a single iterator was preferred as this is more in line with "stream based" thinking.
- **Note:** Uses the Senzing_API.tgz TarBall method of installation.
