# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The `resolver` is a Senzing entity resolution tool that performs resolution on a single set of input records without persistence. It receives records, sends them to Senzing, and queries Senzing for the resolved entities.

- **Main Script**: [resolver.py](resolver.py) (~1583 lines) - Single-file Python application
- **Runtime**: Can run as CLI tool or Docker container
- **Operating Modes**:
  - `file-input`: Batch processing from JSON lines file
  - `service`: HTTP API service (Flask)
  - `sleep`: For Docker testing
  - `version`: Print version info
  - `docker-acceptance-test`: Container testing

## Architecture

### Core Components

**G2Client Class** ([resolver.py:782](resolver.py#L782))
- Manages Senzing engine operations
- Handles dynamic data source registration
- Implements configuration hot-reloading via `is_g2_default_configuration_changed()` and `update_active_g2_configuration()`
- Key methods: `add_record()`, `add_data_source()`, `get_resolved_entities()`

**G2Initializer Class** ([resolver.py:1008](resolver.py#L1008))
- Initializes Senzing database and configuration
- Ensures database schema and default config exist

**Singleton Pattern**
- Global singletons for: `G2_ENGINE_SINGLETON`, `G2_CONFIG_SINGLETON`, `G2_CONFIGURATION_MANAGER_SINGLETON`
- Factory functions: `get_g2_engine()`, `get_g2_config()`, `get_g2_configuration_manager()`

**Configuration System**
- `CONFIGURATION_LOCATOR` dict defines all config parameters with CLI args, environment variables, and defaults
- Configuration priority: CLI args > Environment variables > Defaults
- Key configs: database URL, data/etc/var directories, ports, Senzing directories

**Multi-Version SDK Support**
- Supports both Senzing SDK v2 and v3
- Runtime detection via import attempts
- Backports methods for v2 compatibility (e.g., `initV2`, `reinitV2`)

### HTTP Service Architecture

**Flask Application** ([resolver.py:84](resolver.py#L84))
- Single endpoint: `POST /resolve`
- Query parameters: `withJson=true`, `withFeatures=true` control entity detail level
- Request body: JSON lines (newline-delimited JSON records)
- Default port: 8252 (configurable via `--port` or `SENZING_PORT`)

**Request Flow**:
1. Receive JSON lines in POST body
2. For each record: call `add_record()` to insert into Senzing
3. Auto-register new data sources on-the-fly
4. Query resolved entities using configured flags
5. Return consolidated entity resolution results

## Development Commands

### Building

```bash
# Docker build (recommended)
make docker-build
# or
docker build --tag senzing/resolver .

# Docker build with specific tag
docker build --tag senzing/resolver:$(git describe --always --tags) .
```

### Running Locally

**Prerequisites**: Senzing API must be installed. Set environment variables:
```bash
export LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:$LD_LIBRARY_PATH
export PYTHONPATH=/opt/senzing/g2/python
```

**File-based resolution**:
```bash
./resolver.py file-input \
  --input-file test/test-data-1.json \
  --output-file resolver-output.json
```

**HTTP service**:
```bash
./resolver.py service
# Listens on http://0.0.0.0:8252 by default

# Test with curl:
curl -X POST \
  --header "Content-Type: text/plain" \
  --data-binary @test/test-data-1.json \
  http://localhost:8252/resolve
```

**Common CLI options** (apply to most subcommands):
- `--database-url`: Database connection string (default: SQLite)
- `--data-dir`, `--etc-dir`, `--var-dir`: Senzing directory locations
- `--data-source`: Default data source for records (default: "TEST")
- `--debug`: Enable debug logging
- `--with-json`, `--with-features`: Include additional entity data

### Linting

```bash
# Run pylint (same as CI)
pylint $(git ls-files '*.py')

# Configuration in .pylintrc - many rules disabled for this project
```

### Testing

```bash
# No automated tests currently - testing done via:
# 1. Docker acceptance test
./resolver.py docker-acceptance-test

# 2. Manual file input test
./resolver.py file-input --input-file test/test-data-1.json

# 3. Manual service test
./resolver.py service &
curl -X POST --data-binary @test/test-data-1.json http://localhost:8252/resolve
```

## Docker

**Base Image**: `senzing/senzingapi-runtime:3.13.0`

**Multi-stage Build**:
1. Builder stage: Installs Python dependencies into virtual environment
2. Runner stage: Copies venv, minimal runtime dependencies

**Key Directories**:
- `/app/resolver.py`: Main script
- `/app/venv`: Python virtual environment
- `/var/opt/senzing-internal`: Working directory for internal DB (user 1001)
- `/opt/senzing/g2`: Senzing SDK location

**Port**: 5000 (Flask default), but defaults to 8252 via CMD

**Default Command**: `service` (starts HTTP API)

## Important Notes

### Senzing SDK Version Handling
- Code detects SDK version at runtime (`SENZING_SDK_VERSION_MAJOR`)
- V3: Uses new `senzing` module imports
- V2: Falls back to legacy `G2Engine`, `G2Config` imports
- Always verify SDK-specific behavior when modifying G2 engine calls

### Configuration Hot-Reloading
- System checks for config changes when `add_record()` fails
- If database config differs from in-memory config, automatically reinitializes
- Prevents "thundering herd" with `last_configuration_check` timing

### Database URL Parsing
- `parse_database_url()` converts generic URLs to Senzing-specific format
- Supports SQLite, PostgreSQL, MySQL, MSSQL, DB2
- Special handling for internal database (`SENZING_INTERNAL_DATABASE`)

### Data Source Management
- Records can specify `DATA_SOURCE` field, or use default from config
- New data sources automatically registered via `add_data_source()`
- Data sources tracked in `G2Client.data_sources` list to avoid duplicate registration

## File Structure

```
resolver/
├── resolver.py              # Main application (~1583 lines, single-file architecture)
├── requirements.txt         # Flask==3.1.2, flask_api==3.1
├── Dockerfile              # Multi-stage build
├── Makefile                # Docker build automation
├── .pylintrc               # Pylint configuration (many rules disabled)
├── test/
│   └── test-data-1.json    # Sample test data (10 JSON records)
├── rootfs/
│   └── app/
│       ├── healthcheck.sh   # Docker healthcheck
│       ├── container-test.sh
│       └── sleep-infinity.sh
└── docs/
    ├── development.md       # Development setup guide
    ├── demonstrate-using-command-line.md
    ├── demonstrate-using-docker.md
    ├── examples.md          # HTTP API examples
    └── errors.md
```

## CI/CD

**Pylint Workflow** ([.github/workflows/pylint.yaml](.github/workflows/pylint.yaml))
- Runs on: Pull requests to main
- Python versions: 3.10, 3.11, 3.12, 3.13
- Command: `pylint $(git ls-files '*.py')`
- Install: `python -m pip install --group all .`

**Docker Workflows**
- `docker-build-container.yaml`: Builds and tags container
- `docker-push-containers-to-dockerhub.yaml`: Publishes to DockerHub
- `docker-verify-refreshed-at-updated.yaml`: Validates Dockerfile REFRESHED_AT

## Configuration Reference

Key environment variables (all have CLI equivalents):
- `SENZING_DATABASE_URL`: Database connection (default: SQLite in `/var/opt/senzing/sqlite/G2C.db`)
- `SENZING_DATA_DIR`: Senzing data directory (default: `/opt/senzing/data`)
- `SENZING_ETC_DIR`: Config directory (default: `/etc/opt/senzing`)
- `SENZING_G2_DIR`: G2 SDK directory (default: `/opt/senzing/g2`)
- `SENZING_VAR_DIR`: Variable files (default: `/var/opt/senzing`)
- `SENZING_HOST`: HTTP service host (default: `0.0.0.0`)
- `SENZING_PORT`: HTTP service port (default: `8252`)
- `SENZING_DATA_SOURCE`: Default data source (default: `TEST`)
- `SENZING_INTERNAL_DATABASE`: Internal DB for ephemeral use
- `SENZING_DEBUG`: Enable debug mode

## Common Patterns

**Adding a New Subcommand**:
1. Add entry to `subcommands` dict in `get_parser()`
2. Define arguments and help text
3. Create `do_<subcommand>(subcommand, args)` function
4. Add case to main execution block

**Modifying G2 Engine Flags**:
- Flags defined in `G2EngineFlags` class (line 67-76 for v2 compat)
- HTTP service uses: `G2_EXPORT_INCLUDE_ALL_ENTITIES | G2_ENTITY_BRIEF_DEFAULT_FLAGS`
- Optional flags: `G2_ENTITY_INCLUDE_RECORD_JSON_DATA`, `G2_ENTITY_INCLUDE_ALL_FEATURES`

**Error Handling**:
- Use `message_error()`, `message_warning()`, `message_info()` for logging
- Message IDs defined at top of message functions (1xx=info, 3xx=warning, etc.)
- `exit_error()` logs and exits with error code
