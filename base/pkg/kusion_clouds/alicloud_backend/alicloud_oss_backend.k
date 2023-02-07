import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud

schema OSSRender[inputData: alicloud.AlicloudOSSBucket]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    data: alicloud.AlicloudOSSBucket = inputData
    provider: commons.ResourceBuilder = {
        type = "alicloud_oss_bucket"
        name = data.bucket
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = data
    }

_oss_attrs = alicloud.AlicloudOSSBucket.instances()

oss_provider = [ commons.ResourceBuilder {
    type = "alicloud_oss_bucket"
    name = _oss_attr.bucket
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _oss_attr
} for _oss_attr in _oss_attrs ]
