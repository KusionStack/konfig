import base.pkg.kusion_models.commons

alicloudProvider = commons.Provider {
    host = "registry.terraform.io"
    namespace = "aliyun"
    name = "alicloud"
    version = "1.201.1"
}

alicloudProviderMeta = {
    region           = "cn-beijing"
    access_key       = option("alicloud-ak") or Undefined
    secret_key       = option("alicloud-sk") or Undefined
}
