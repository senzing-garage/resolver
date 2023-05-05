# resolver

## Synopsis

Performs resolution on a single set of input records.  There is no persistence of input records.

## Overview

The [resolver.py](resolver.py) python script receives records, sends the records to Senzing, then queries Senzing for the resolved entities.
The `senzing/resolver` docker image is a wrapper for use in docker formations (e.g. docker-compose, kubernetes).

To see all of the subcommands, run:

```console
$ ./resolver.py
usage: resolver.py [-h]
                   {file-input,service,sleep,version,docker-acceptance-test}
                   ...

Resolve entities. For more information, see
https://github.com/Senzing/resolver

positional arguments:
  {file-input,service,sleep,version,docker-acceptance-test}
                        Subcommands (SENZING_SUBCOMMAND):
    file-input          File based input / output.
    service             Receive HTTP requests.
    sleep               Do nothing but sleep. For Docker testing.
    version             Print version of resolver.py.
    docker-acceptance-test
                        For Docker acceptance testing.

optional arguments:
  -h, --help            show this help message and exit
```

To see the options for a subcommand, run commands like:

```console
./resolver.py service --help
```

### Contents

1. [Preamble](#preamble)
1. [Expectations](#expectations)
1. [Demonstrate](#demonstrate)
1. [References](#references)

## Preamble

At [Senzing](http://senzing.com),
we strive to create GitHub documentation in a
"[don't make me think](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/dont-make-me-think.md)" style.
For the most part, instructions are copy and paste.
Whenever thinking is needed, it's marked with a "thinking" icon :thinking:.
Whenever customization is needed, it's marked with a "pencil" icon :pencil2:.
If the instructions are not clear, please let us know by opening a new
[Documentation issue](https://github.com/Senzing/resolver/issues/new?assignees=&labels=&template=documentation_request.md)
describing where we can improve.   Now on with the show...

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps you'll need to make some choices.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

## Expectations

- **Space:** This repository and demonstration require 20 GB free disk space.
- **Time:** Budget 4 hours to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/docker.md)
  - [Kubernetes](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/kubernetes.md)
  - [Helm](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/helm.md)

## Demonstrate

1. [Demonstrate using Command Line](docs/demonstrate-using-command-line.md)
1. [Demonstrate using Docker](docs/demonstrate-using-docker.md)
1. [Demonstrate using Docker-compose](docs/demonstrate-using-docker-compose.md)
1. [Demonstrate using Kubernetes and Helm](docs/demonstrate-using-kubernetes-and-helm.md)

## References

1. [Development](docs/development.md)
1. [Errors](docs/errors.md)
1. [Examples](docs/examples.md)
1. Related artifacts:
    1. [DockerHub](https://hub.docker.com/r/senzing/resolver)
    1. [Helm Chart](https://github.com/Senzing/charts/tree/main/charts/resolver)
