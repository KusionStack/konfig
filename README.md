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
├── LICENSE
├── Makefile
├── README-zh.md
├── README.md
├── examples
├── kcl.mod
├── kcl.mod.lock
├── models
│   ├── commons
│   └── kube
│       ├── backend
│       │   ├── job_backend.k
│       │   └── server_backend.k
│       ├── frontend
│       │   ├── common
│       │   │   └── metadata.k
│       │   ├── configmap
│       │   │   └── configmap.k
│       │   ├── container
│       │   │   ├── container.k
│       │   │   ├── env
│       │   │   │   └── env.k
│       │   │   ├── lifecycle
│       │   │   │   └── lifecycle.k
│       │   │   ├── port
│       │   │   │   └── container_port.k
│       │   │   └── probe
│       │   │       └── probe.k
│       │   ├── ingress
│       │   │   └── ingress.k
│       │   ├── job.k
│       │   ├── rbac
│       │   │   ├── cluster_role.k
│       │   │   ├── cluster_role_binding.k
│       │   │   ├── role.k
│       │   │   └── role_binding.k
│       │   ├── resource
│       │   │   ├── resource.k
│       │   │   └── resource_requirements.k
│       │   ├── secret
│       │   │   └── secret.k
│       │   ├── server.k
│       │   ├── service
│       │   │   └── service.k
│       │   ├── serviceaccount
│       │   │   └── service_account.k
│       │   ├── sidecar
│       │   │   ├── sidecar.k
│       │   │   └── simple_sidecar.k
│       │   ├── storage
│       │   │   ├── database.k
│       │   │   └── objectstorage.k
│       │   ├── strategy
│       │   │   └── scheduling_strategy.k
│       │   └── volume
│       │       └── volume.k
│       ├── metadata
│       │   └── metadata.k
│       ├── mixins
│       │   ├── configmap_mixin.k
│       │   ├── ingress_mixin.k
│       │   ├── metadata_mixin.k
│       │   ├── namespace_mixin.k
│       │   ├── secret_mixin.k
│       │   ├── service_mixin.k
│       │   └── serviceaccount_mixin.k
│       ├── protocol
│       │   └── server_protocol.k
│       ├── render
│       │   └── render.k
│       ├── resource
│       │   ├── resource.k
│       │   └── resourceorder.k
│       ├── templates
│       │   └── resource.k
│       └── utils
│           ├── application_builder.k
│           ├── container_frontend2kube.k
│           ├── metadata_builder.k
│           ├── str2resource_requirements.k
│           ├── str2resource_requirements_test.k
│           └── volume_patch.k
└── scripts
    └── test.sh
```

## Prerequisites

Install [kpm](https://kcl-lang.io/docs/user_docs/guides/package-management/installation)

## Quick Start

See [here](https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/guide)

## License

Apache License Version 2.0
