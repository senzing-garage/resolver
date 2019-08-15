# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2019-08-15

### Added in 1.0.0

- Subcommands:
  - `resolver.py service`
  - `resolver.py file-input`
- Note: a "batch mode" datasource/entity-type configurator was attempted,  but was replaced with "on the fly" configuration.
  Reason: File-based iterators could not be reset, so two iterators would be needed -- potentially bloating memory.
  The use of a single iterator was preferred as this is more in line with "stream based" thinking.
 - **Note:** Uses the Senzing_API.tgz TarBall method of installation.
