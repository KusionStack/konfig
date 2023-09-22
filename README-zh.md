# Konfig

[![用 GitHub Codespaces 打开](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=488867056&machine=standardLinux32gb&devcontainer_path=.devcontainer.json)

[英语](README.md) | [中文](README-zh.md)

Konfig 是 KCL 配置中基础设施配置的单一存储库。Konfig 提供给用户开箱即用、高度抽象的配置界面，模型库最初朴素的出发点就是改善 YAML 用户的效率和体验，我们希望通过将代码更繁杂的模型抽象封装到统一的模型中，从而简化用户侧配置代码的编写。当然您也可以使用 kpm 工具将 Konfig 代码作为依赖集成到您的配置代码中。

更多细节可参考：[《模型概览》](https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/overview)

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
├── base                # 模型库
│   ├── examples        # 样例代码
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

## 快速开始

参考[这里](https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/guide)

## License

Apache License Version 2.0
