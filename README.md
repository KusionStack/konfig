# Konfig

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=488867056&machine=standardLinux32gb&devcontainer_path=.devcontainer.json)

[English](README.md) | [Chinese](README-zh.md)

Konfig is the mono repository of the infra configuration in KCL(Kusion Configuration Language).

Konfig provides users with an out-of-the-box, highly abstract configuration interface. The original starting point of the model library is to improve the efficiency and experience of YAML users. We hope to simplify the writing of user-side configuration code by abstracting and encapsulating the model with more complex code into a unified model.

For more details, please refer to: [Model Overview](https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/overview)

## Directory Structure

The overall structure of the configuration library is as follows:

```bash
.
├── Makefile            # use Makefile to encapsulate common commands
├── README.md           # configuration library instructions
├── appops              # application operation and maintenance directory
│   ├── clickhouse-operator
│   ├── code-city
│   ├── guestbook
│   ├── http-echo
│   └── nginx-example
├── base                # Model repository
│   ├── examples        # Model example code
│   │   ├── monitoring  # monitoring configuration example
│   │   ├── native      # Kubernetes resource configuration example
│   │   ├── provider    # infrastructure configuration example
│   │   └── server      # cloud native configuration model example
│   └── pkg
│       ├── kusion_kubernetes   # Kubernetes low-level model library
│       ├── kusion_models       # core model library
│       ├── kusion_prometheus   # Prometheus low-level model library
│       └── kusion_provider     # infrastructure low-level model library
├── hack                # python scripts
└── kcl.mod             # core library configuration file
```

## Quick Start

See [here](https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/guide)

## License

Apache License Version 2.0
