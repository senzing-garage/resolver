# resolver

If you are beginning your journey with [Senzing],
please start with [Senzing Quick Start guides].

You are in the [Senzing Garage] where projects are "tinkered" on.
Although this GitHub repository may help you understand an approach to using Senzing,
it's not considered to be "production ready" and is not considered to be part of the Senzing product.
Heck, it may not even be appropriate for your application of Senzing!

## Synopsis

Performs resolution on a single set of input records. There is no persistence of input records.

## Overview

The [resolver.py] python script receives records, sends the records to Senzing, then queries Senzing for the resolved entities.
The `senzing/resolver` docker image is a wrapper for use in docker formations (e.g. docker-compose, kubernetes).

To see all of the subcommands, run:

```console
$ ./resolver.py
usage: resolver.py [-h]
                   {file-input,service,sleep,version,docker-acceptance-test}
                   ...

Resolve entities. For more information, see
https://github.com/senzing-garage/resolver

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

1. [Preamble]
1. [Expectations]
1. [Demonstrate]
1. [References]

## Preamble

At [Senzing], we strive to create GitHub documentation in a
"[don't make me think]" style. For the most part, instructions are copy and paste.
Whenever thinking is needed, it's marked with a "thinking" icon :thinking:.
Whenever customization is needed, it's marked with a "pencil" icon :pencil2:.
If the instructions are not clear, please let us know by opening a new
[Documentation issue] describing where we can improve. Now on with the show...

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps you'll need to make some choices.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

### Expectations

- **Space:** This repository and demonstration require 20 GB free disk space.
- **Time:** Budget 4 hours to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker]
  - [Kubernetes]
  - [Helm]

## Demonstrate

1. [Demonstrate using Command Line]
1. [Demonstrate using Docker]
1. [Demonstrate using Docker-compose]
1. [Demonstrate using Kubernetes and Helm]

## References

1. [Development]
1. [Errors]
1. [Examples]
1. Related artifacts:
   1. [DockerHub]
   1. [Helm Chart]

[Demonstrate using Command Line]: docs/demonstrate-using-command-line.md
[Demonstrate using Docker-compose]: docs/demonstrate-using-docker-compose.md
[Demonstrate using Docker]: docs/demonstrate-using-docker.md
[Demonstrate using Kubernetes and Helm]: docs/demonstrate-using-kubernetes-and-helm.md
[Demonstrate]: #demonstrate
[Development]: docs/development.md
[Docker]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md
[DockerHub]: https://hub.docker.com/r/senzing/resolver
[Documentation issue]: https://github.com/senzing-garage/resolver/issues/new?assignees=&labels=&template=documentation_request.md
[don't make me think]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/dont-make-me-think.md
[Errors]: docs/errors.md
[Examples]: docs/examples.md
[Expectations]: #expectations
[Helm Chart]: https://github.com/senzing-garage/charts/tree/main/charts/resolver
[Helm]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/helm.md
[Kubernetes]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/kubernetes.md
[Preamble]: #preamble
[References]: #references
[resolver.py]: resolver.py
[Senzing Garage]: https://github.com/senzing-garage
[Senzing Quick Start guides]: https://docs.senzing.com/quickstart/
[Senzing]: https://senzing.com/
