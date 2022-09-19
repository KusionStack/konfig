# 前言

> 本 README.md 包括配置代码仓库目录/文件说明及如何本地使用 Kusion+Minikube 进行测试

## 快速开始

1. 查看应用目录 base/base.k 和 prod/main.k 文件中的配置是否符合预期，如果不符合预期，可自行修改

```bash
# 进入应用目录
cd clickhouse-operator
# 查看应用配置
cat base/base.k
# 查看环境配置
cat prod/main.k 
```

2. 编译（编译 .k 文件，生成 YAML）

```bash
cd prod
kusion compile
# 查看编译结果
cat stdout.golden.yaml
```

3. 测试：使用 kusion 将 prod 环境配置一键下发 minikube 本地集群中

```bash
# test.kubeconfig 需要替换为测试集群的证书
export KUBECONFIG=test.kubeconfig

# 部署到集群
kusion apply

# 查看拍到集群中的资源
kubectl get deployment -n demo
kubectl get namespace

# 删除拍到集群中的资源
kusion destory
```

## 目录和文件说明

```bash
.
├── OWNERS                      // 租户信息
├── README.md                   // 说明文档
├── base                        // 各环境通用配置
│   ├── base.k                  // 应用配置
│   ├── rbac.k                  // 应用 RBAC 配置
│   └── templates               // 应用依赖的常量配置
│       ├── etc-clickhouse-operator-confd-files.k
│       ├── etc-clickhouse-operator-configd-files.k
│       ├── etc-clickhouse-operator-files.k
│       ├── etc-clickhouse-operator-templatesd-files.k
│       └── etc-clickhouse-operator-usersd-files.k
├── crd                         // CRD 配置
│   ├── clickhouseinstallations.yaml
│   ├── clickhouseinstallationtemplates.yaml
│   └── clickhouseoperatorconfigurations.yaml
├── prod                        // 环境目录
│   └── ci-test                 // 测试目录，放置测试脚本和数据
│   │   ├── settings.yaml       // 测试数据和编译文件配置
│   │   └── stdout.golden.yaml  // 期望的 YAML，可通过 make 更新
│   ├── kcl.yaml                // 编译入口文件配置
│   ├── main.k                  // 应用在当前环境的配置清单
│   └── stack.yaml              // stack 标识，stack 基础信息
└── project.yaml                // project 标识，project 基础信息
```
