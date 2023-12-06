[package]
name = "samplejob"
edition = "0.1.0"
version = "0.1.0"

[dependencies]
catalog = { git = "https://github.com/KusionStack/catalog.git", tag = "0.1.1" }
[profile]
entries = ["main.k"]

