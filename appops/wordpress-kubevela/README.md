# 前言

> 本 README.md 包括配置代码仓库目录/文件说明及如何本地使用 Kusion 进行测试

## 快速开始
```bash
$ cd dev
$ export ALICLOUD_ACCESS_KEY="***************"
$ export ALICLOUD_SECRET_KEY="***************"
$ kusion apply --yes
 ✔︎  Generating Spec in the Stack dev...                                                                                                                                                                                        

Stack: dev  ID                                                            Action
 * ├─       aliyun:alicloud:alicloud_vpc:wordpress-example-dev            Create
 * ├─       aliyun:alicloud:alicloud_vswitch:wordpress-example-dev        Create
 * ├─       aliyun:alicloud:alicloud_db_instance:wordpress-example-dev    Create
 * ├─       aliyun:alicloud:alicloud_db_connection:wordpress-example-dev  Create
 * ├─       aliyun:alicloud:alicloud_rds_account:root                     Create
 * └─       core.oam.dev/v1beta1:Application:dev:wordpress-example        Create

Start applying diffs ...
  SUCCESS  Create aliyun:alicloud:alicloud_vpc:wordpress-example-dev success
  SUCCESS  Create aliyun:alicloud:alicloud_vswitch:wordpress-example-dev success
  SUCCESS  Create aliyun:alicloud:alicloud_db_instance:wordpress-example-dev success
  SUCCESS  Create aliyun:alicloud:alicloud_db_connection:wordpress-example-dev success
  SUCCESS  Create core.oam.dev/v1beta1:Application:dev:wordpress-example success
  SUCCESS  Create aliyun:alicloud:alicloud_rds_account:root success
Create aliyun:alicloud:alicloud_rds_account:root success [6/6] ███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████ 100% | 4m30s
Apply complete! Resources: 6 created, 0 updated, 0 deleted.

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
│   └── main.k                  // 应用在当前环境的应用开发者关注的配置清单
│   └── platform.k              // 应用在当前环境的平台开发者关注的配置清单
│   └── stack.yaml              // Stack 元信息
└── project.yaml	            // Project 元信息
└── README.md                   // 说明文档
```
