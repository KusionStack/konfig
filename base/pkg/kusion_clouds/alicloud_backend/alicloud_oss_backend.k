import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud

schema OSSRender[inputData: alicloud.AlicloudOSSBucket]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudOSSBucketMeta.type
        name = inputData.bucket
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }

_oss_attrs = alicloud.AlicloudOSSBucket.instances()

oss_provider = [ commons.ResourceBuilder {
    type = alicloud_config.alicloudOSSBucketMeta.type
    name = _oss_attr.bucket
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _oss_attr
} for _oss_attr in _oss_attrs ]
