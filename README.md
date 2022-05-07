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

## 模型设计规范

主要有以下几条原则：

- 请使用一个属性代替配置模板
- 请使用字面值类型 Literal Type
- 请使用联合类型 Union Type
- 列表/数组属性应字典化
- 应为模型书写校验表达式
- 使用数值单位类型
- 为模型添加代码注释

## 贡献指南

模型设计提案：

1. 请提交「模型设计提案」到 Issue （TODO：link），「模型设计提案」应该包含以下几部分：
   - 目的：说明该模型设计提案的背景及目的
   - 内容：说明模型设计提案的内容
   - 使用方法：说明该提案的使用方法
2. 提交 Issue 后，通过评审即可开始模型实现，原型 PR、进度都需要在 Issue 页面中评论跟踪
3. 实现&评审完毕，关闭 Issue

Pull Request：

- 对模型库（./base）的修改请添加评审人：[elliotxx](https://github.com/elliotxx)
