# Konfig

Konfig is the mono repository of the infra configuration in KCL(Kusion Configuration Language).

## 基本概念

- **Konfig 配置大库**：基于 KCL 描述的配置代码仓库，简称**大库**；大库中的模型分为：前端模型，后端模型；
- **Kusion Model**：也叫做 Kusion 模型库，是 Kusion 技术栈中预置的、用 KCL 描述的配置模型，它提供给用户开箱即用、高度抽象的配置接口，Kusion Model 由以下部分组成：
  - **底层模型**：是不包含任何实现逻辑和抽象的模型，往往由工具转换生成，无需修改，和真正生效的 YAML 属性一一对应，底层模型需要经过进一步抽象，一般不直接被用户使用。比如，kusion_kubernetes 是 Kubernetes 场景的底层模型；
  - **核心模型**：
    - **前端模型**：前端模型即「用户界面」，包含平台侧暴露给用户的所有可配置属性，其中省略了一些重复的、可推导的配置，抽象出必要属性暴露给用户，具有用户友好的特性。
    - **后端模型**：后端模型是「模型实现」，是让前端模型属性生效的模型，主要包含前端模型实例的渲染逻辑，后端模型中可借助 KCL 编写校验、逻辑判断、代码片段复用等代码，提高配置代码复用性和健壮性，对用户不感知
- **前端模型**：前端模型即「用户界面」，包含平台侧暴露给用户的所有可配置属性，其中省略了一些重复的、可推导的配置，抽象出必要属性暴露给用户，具有用户友好的特性。用户只需要像实例化一个类（Class）一样，传入必要参数构成一份应用的「配置清单」，经过工具链编译即可得到完整的 Kubernetes Manifests，其中包含 Deployment、Service 等 Kubernetes 资源；
- **后端模型**：后端模型是「模型实现」，是让前端模型属性生效的模型，主要包含前端模型实例的渲染逻辑，后端模型中可借助 KCL 编写校验、逻辑判断、代码片段复用等代码，提高配置代码复用性和健壮性，对用户不感知；
- **底层模型**：是不包含任何实现逻辑和抽象的模型，往往由工具转换生成，无需修改，和真正生效的 YAML 属性一一对应；比如，kusion_kubernetes 是 Kubernetes 场景的底层模型；

FAQ:

- **为什么要区分前端模型和后端模型**？
  区分前端模型和后端模型的直接目的是将「用户界面」和「模型实现」进行分离；

更多细节可参考：[《模型概览》](https://KusionStack.io/docs/reference/model/overview)

## 目录结构概览

配置大库整体结构如下：

```bash
.
├── Makefile            # 通过 Makefile 封装常用命令
├── README.md           # 配置大库说明
├── appops              # 应用运维目录，用来放置所有应用的 KCL 运维配置
│   ├── guestbook-frontend
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

2、可用的 Kubernetes 集群

必须要有一个 Kubernetes 集群，同时 Kubernetes 集群最好带有 kubectl 命令行工具。 如果你还没有集群，你可以通过 Minikube 构建一个你自己的集群。

### Server 样例

有关 Server 模型的使用样例在 `base/examples/server` 目录下。这里，我们以 `app_service` 作为演示项目。

该目录的子目录分为以下几个模块：
- base：Project 级别配置，也叫基础配置，起到公共配置的作用；
- prod：Stack 级别配置，可以扩充 Project 配置，也可以覆盖；
- project.yaml：Project 基础信息

其中，`base/bae.k` 和 `prod/main.k` 是核心代码，直接查看源码文件即可。

#### 配置编译

执行以下命令：
```shell
kusion compile -w base/examples/server/app_service/prod
```

编译结果输出在 `base/examples/server/app_service/prod/ci-test/stdout.golden.yaml` 文件中。

更多细节请参考：[《使用指南》](https://kusionstack.io/docs/reference/konfig/guide)。

#### 配置生效

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