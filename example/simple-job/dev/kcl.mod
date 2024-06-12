[package]
name = "simple-job"
version = "0.1.0"

[dependencies]
kam = { git = "https://github.com/KusionStack/kam.git", tag = "0.2.0" }
job = { oci = "oci://ghcr.io/kusionstack/job", tag = "0.1.0" }

[profile]
entries = ["main.k"]

