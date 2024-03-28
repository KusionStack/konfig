[package]
name = "simple-service"
version = "0.1.0"

[dependencies]
kam = { git = "https://github.com/KusionStack/kam.git", tag = "0.1.0" }
network = { oci = "oci://ghcr.io/kusionstack/network", tag = "0.1.0" }
opsrule = { oci = "oci://ghcr.io/kusionstack/opsrule", tag = "0.1.0" }
monitoring = { oci = "oci://ghcr.io/kusionstack/monitoring", tag = "0.1.0" }

[profile]
entries = ["main.k"]

