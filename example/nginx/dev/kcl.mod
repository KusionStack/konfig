[package]
name = "public-service"
edition = "0.5.0"
version = "0.1.0"

[dependencies]
# should update the tag!
catalog = { git = "https://github.com/KusionStack/catalog.git", tag = "0.1.2" }

[profile]
entries = ["main.k"]
