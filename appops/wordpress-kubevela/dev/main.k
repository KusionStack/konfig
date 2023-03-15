import base.pkg.kusion_models.kube.frontend

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
mysql = frontend.Server {
    # for macOS with M1 chip: mysql@sha256:897086d07d1efa876224b147397ea8d3147e61dd84dce963aace1d5e9dc2802d
    image = "mysql:5.6"    
    renderType = "KubeVelaApplication"
}
wordpress = frontend.Server {
    image = "wordpress:4.8-apache"
    renderType = "KubeVelaApplication"
    
    storage = storage.ObjectStorage {
        objectStorageType = "aliyun_oss"
        objectStorageAttr = storage.StorageAttr {
            bucket = "kusion-oss"
            acl    = "public-read"
        }
    }
}
