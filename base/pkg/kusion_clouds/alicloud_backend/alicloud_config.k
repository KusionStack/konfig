import base.pkg.kusion_models.commons

alicloudProvider = commons.Provider {
    host = "registry.terraform.io"
    namespace = "aliyun"
    name = "alicloud"
    version = "1.153.0"
}

alicloudProviderMeta = {
    region           = "cn-beijing"
}
