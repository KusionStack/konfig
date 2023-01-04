# Konfig
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=488867056&machine=standardLinux32gb&devcontainer_path=.devcontainer.json)

[English](README.md) | [Chinese](README-zh.md)

Konfig is the mono repository of the infra configuration in KCL(Kusion Configuration Language).

Konfig, also known as Kusion Model, is a configuration model library preset in KusionStack and described by KCL.
It provides users with an out-of-the-box, highly abstract configuration interface.
The original starting point of the model library is to improve the efficiency and experience of YAML users.
We hope to simplify the writing of user-side configuration code by abstracting
and encapsulating the model with more complex code into a unified model.

For more details, please refer to: [Model Overview](https://KusionStack.io/docs/reference/model/overview)

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
├── base                # Kusion Model repository
│   ├── examples        # Kusion Model example code
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

For more details, please refer to: [Configuration Library Structure Overview](https://KusionStack.io/docs/develop/design/konfig)

## Quick Start

Next, I will show you how to use the KCL language and its corresponding CLI tool Kusion to
complete the deployment of a long-running application running in Kubernetes.
We call the unit of organization configuration as *Application*,
which describes application deployment and The configuration set of
operation and maintenance details is called *Server*,
which is essentially the operation and maintenance model defined by KCL.
The complete server model definition can be seen here:
[Server](https://github.com/KusionStack/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k).

### Prerequisites

Before we start, we need to do the following preparations:

1. Install the Kusion toolchain

   We strongly recommend yoy to use kusion's official installation tool kusionup,
   which can implement key capabilities such as kusion multi-version management.
   See [Download and Install](https://kusionstack.io/docs/user_docs/getting-started/install) for details.

2. Download the Core Config library

   In this guide, you need to use some KCL models that have been abstractly implemented.
   For an introduction to the KCL language, you can refer to
   [Tour of KCL](https://kusionstack.io/docs/reference/lang/lang/tour).

3. Available Kubernetes Cluster

   A Kubernetes cluster is required, preferably with the kubectl command line tool.
   If you don't have a cluster yet, you can build your own with Minikube.

### Server Example

Examples of using the Server model are in the `base/examples/server` directory.
Here, we use `app_service` as a demo project.

The subdirectories of this directory are divided into the following modules:
- base: Project-level configuration, also called basic configuration, plays the role of public configuration;
- prod: Stack-level configuration, which can expand or override the Project configuration;
- project.yaml: Project basic information

Among them, `base/bae.k` and `prod/main.k` are the core code, you can directly view the source code file.

### Configuration Compile

Execute the following commands:

```shell
kusion compile -w base/examples/server/app_service/prod
```

The compilation result is output in the `base/examples/server/app_service/prod/ci-test/stdout.golden.yaml` file.

For more details, please refer to: [User Guide](https://kusionstack.io/docs/reference/konfig/guide).

### Configuration Takes Effect

After the compilation is completed, now start to distribute the configuration to the Minikube cluster and check the effective result.

Execute the following commands:

```shell
kusion apply -w base/examples/server/app_service/prod
```

The output is similar to:

```shell
 SUCCESS  Compiling in stack prod...                                                                                    

Stack: prod  ID                                          Action
 * ├─        v1:Namespace:sampleapp                      Create
 * ├─        apps/v1:Deployment:sampleapp:sampleappprod  Create
 * └─        v1:Service:sampleapp:frontend               Create

? Do you want to apply these diffs?  [Use arrows to move, type to filter]
  yes
> details
  no
```

Move the cursor and select `yes` to start applying the configuration, the output is similar to:

```shell
Start applying diffs......
 SUCCESS  Creating Namespace/sampleapp
 SUCCESS  Creating Deployment/sampleappprod
 SUCCESS  Creating Service/frontend
Creating Service/frontend [3/3] ███████████████████████████████████████████ 100% | 0s

Apply complete! Resources: 3 created, 0 updated, 0 deleted.
```

Now, you can use the [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) tool to check the resource creation result.

For more details on the use of Konfig, please refer to: [User Guide](https://kusionstack.io/docs/reference/konfig/guide).

## Contribution Guidelines

### Model Design Specifications

- Please use a property instead of the config template
- Please use Literal Type
- Please use Union Type
- List/array properties should be lexicographic
- Validation expressions should be written for the model
- Use numeric unit type
- Add code comments to models

### Model Design Proposal

1. Please submit "Model Design Proposal" to Issue.
   The "Model Design Proposal" should include the following parts:
   - Purpose: Explain the background and purpose of this mockup design proposal
   - Content: Describe the content of the model design proposal
   - How to use: Explain how to use the proposal
2. After submitting the issue, the model implementation can be started through the review.
   Prototype PR and progress need to be tracked by comments on the Issue page
3. After the implementation & review is completed, close the Issue

## License

Apache License Version 2.0
