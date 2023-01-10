# Konfig

[![用 GitHub Codespaces 打开](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=488867056&machine=standardLinux32gb&devcontainer_path=.devcontainer.json)


[英语](README.md) | [中文](README-zh.md)

Konfig 是 KCL（Kusion 配置语言）中基础设施配置的单一存储库。

Konfig，也叫做 Kusion Model，是 KusionStack 中预置的、使用 KCL 描述的配置模型，它提供给用户开箱即用、高度抽象的配置界面，模型库最初朴素的出发点就是改善 YAML 用户的效率和体验，我们希望通过将代码更繁杂的模型抽象封装到统一的模型中，从而简化用户侧配置代码的编写。

更多细节可参考：[《模型概览》](https://KusionStack.io/docs/reference/model/overview)

## 目录结构概览

配置大库整体结构如下：

```bash
.
├── Makefile            # 通过 Makefile 封装常用命令
├── README.md           # 配置大库说明
├── appops              # 应用运维目录，用来放置所有应用的 KCL 运维配置
│   ├── clickhouse-operator
│   ├── code-city
│   ├── guestbook
│   ├── http-echo
│   └── nginx-example
├── base                # Kusion Model 模型库
│   ├── examples        # Kusion Model 样例代码
│   │   ├── monitoring  # 监控配置样例
│   │   ├── native      # Kubernetes 资源配置样例
│   │   ├── provider    # 基础资源配置样例
│   │   └── server      # 云原生应用运维配置模型样例
│   └── pkg
│       ├── kusion_kubernetes   # Kubernetes 底层模型库
│       ├── kusion_models       # 核心模型库
│       ├── kusion_prometheus   # Prometheus 底层模型库
│       └── kusion_provider     # 基础资源 底层模型库
├── hack                # 放置一些脚本
└── kcl.mod             # 大库配置文件，通常用来标识大库根目录位置以及大库所需依赖
```

更多细节可参考：[《配置大库结构概览》](https://KusionStack.io/docs/develop/design/konfig)

## 快速开始

接下来向你展示的是，如何使用 KCL 语言与其相对应的 CLI 工具 Kusion，完成一个运行在 Kubernetes 中的 Long-Running 应用的部署，我们将组织配置的单位叫做应用（Application），描述应用部署和运维细节的配置集合叫做应用服务（Server），它本质上是通过 KCL 定义的运维模型，完整的 Server 模型定义可见：[Server](https://github.com/KusionStack/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k)。

### 前提约束

在开始之前，我们需要做以下准备工作：

1、安装 Kusion 工具链

我们推荐使用 kusion 的官方安装工具 kusionup，可实现 kusion 多版本管理等关键能力。详情信息请参阅[下载和安装](https://kusionstack.io/docs/user_docs/getting-started/install)。

2、下载开源 Konfig 大库

在本篇指南中，需要用到部分已经抽象实现的 KCL 模型，有关 KCL 语言的介绍，可以参考 [Tour of KCL](https://kusionstack.io/docs/reference/lang/lang/tour)。

3、可用的 Kubernetes 集群

必须要有一个 Kubernetes 集群，同时 Kubernetes 集群最好带有 kubectl 命令行工具。 如果你还没有集群，你可以通过 Minikube 构建一个你自己的集群。

### Server 样例

有关 Server 模型的使用样例在 `base/examples/server` 目录下。这里，我们以 `app_service` 作为演示项目。

该目录的子目录分为以下几个模块：
- base：Project 级别配置，也叫基础配置，起到公共配置的作用；
- prod：Stack 级别配置，可以扩充 Project 配置，也可以覆盖；
- project.yaml：Project 基础信息

其中，`base/bae.k` 和 `prod/main.k` 是核心代码，直接查看源码文件即可。

### 配置编译

执行以下命令：
```shell
kusion compile -w base/examples/server/app_service/prod
```

编译结果输出在 `base/examples/server/app_service/prod/ci-test/stdout.golden.yaml` 文件中。

更多细节请参考：[《使用指南》](https://kusionstack.io/docs/reference/konfig/guide)。

### 配置生效

编译完成后，现在开始下发配置到 Minikube 集群，检验生效结果。

执行以下命令：

```shell
kusion apply -w base/examples/server/app_service/prod
```

输出类似于：

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

移动光标，选择 `yes`，开始应用配置，输出类似于：

```shell
Start applying diffs......
 SUCCESS  Creating Namespace/sampleapp
 SUCCESS  Creating Deployment/sampleappprod
 SUCCESS  Creating Service/frontend
Creating Service/frontend [3/3] ███████████████████████████████████████████ 100% | 0s

Apply complete! Resources: 3 created, 0 updated, 0 deleted.
```

到此，就可以使用 [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 工具，检查资源创建结果。

更多 Konfig 的使用细节请参考：[《使用指南》](https://kusionstack.io/docs/reference/konfig/guide)。

## 贡献指南

### 模型设计规范

- 请使用一个属性代替配置模板
- 请使用字面值类型 Literal Type
- 请使用联合类型 Union Type
- 列表/数组属性应字典化
- 应为模型书写校验表达式
- 使用数值单位类型
- 为模型添加代码注释

### 模型设计提案

1. 请提交「模型设计提案」到 Issue ，「模型设计提案」应该包含以下几部分：
   - 目的：说明该模型设计提案的背景及目的
   - 内容：说明模型设计提案的内容
   - 使用方法：说明该提案的使用方法
2. 提交 Issue 后，通过评审即可开始模型实现，原型 PR、进度都需要在 Issue 页面中评论跟踪
3. 实现&评审完毕，关闭 Issue

## License

Apache License Version 2.0