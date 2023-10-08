[package]
name = "app_config_map-prod"
version = "0.0.1"

[dependencies]
konfig = { path = "../../../../../konfig" }
k8s = "1.28"
[profile]
entries = ["../base/base.k", "main.k", "${konfig:KCL_MOD}/models/kube/render/render.k"]

