# 前言

> 本 README.md 包括配置代码仓库目录/文件说明及如何本地使用 Kusion+Minikube 进行测试

## 快速开始

```bash
$ cd dev
$ kusion apply --yes=true
 SUCCESS  Compiling in stack dev...                                                                                                   

Stack: dev    Provider                                               Type                       Name    Plan
      * ├─  kubernetes                                       v1:Namespace           kcl-vault-csi[0]  Create
      * ├─  kubernetes                                  v1:ServiceAccount        kcl-vault-csi-sa[0]  Create
      * ├─  kubernetes  secrets-store.csi.x-k8s.io/v1:SecretProviderClass  kcl-vault-csi-database[0]  Create
      * └─  kubernetes                                 apps/v1:Deployment       kcl-vault-csi-dev[0]  Create

Start applying diffs......
 SUCCESS  Creating Namespace/kcl-vault-csi                                                                                            
 SUCCESS  Creating ServiceAccount/kcl-vault-csi-sa                                                                                    
 SUCCESS  Creating SecretProviderClass/kcl-vault-csi-database                                                                         
 SUCCESS  Creating Deployment/kcl-vault-csi-dev                                                                                       
Creating Deployment/kcl-vault-csi-dev [4/4] ██████████████████████████████████████████████████████ 100% | 0s

Apply complete! Resources: 4 created, 0 updated, 0 deleted.

$ kubectl exec -n kcl-vault \
    $(kubectl get pod -n kcl-vault -l app=kcl-vault-test -o jsonpath="{.items[0].metadata.name}") \
    --container kcl-vault-test -- cat /vault/secrets/database-config.txt

data: map[password:db-secret-password username:db-readonly-username]
metadata: map[created_time:2022-03-13T08:40:02.1133715Z custom_metadata:<nil> deletion_time: destroyed:false version:1]

$ kusion destroy
```

## 目录和文件说明

```bash
.
├── base                        // 各环境通用配置
│   ├── base.k                  // 应用的环境通用配置
├── dev                         // 环境目录
│   └── ci-test                 // ci 测试目录，放置测试脚本和数据
│     └── settings.yaml         // 测试数据和编译文件配置
│     └── stdout.golden.yaml    // 期望的 YAML，可通过 make 更新
│   └── kcl.yaml                // 当前 Stack 的多文件编译配置
│   └── main.k                  // 应用在当前环境的配置清单
│   └── stack.yaml              // Stack 元信息
└── project.yaml	              // Project 元信息
└── README.md                   // 说明文档
```
