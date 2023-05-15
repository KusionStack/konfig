import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud
import manifests

schema OSSRender[inputData: alicloud.AlicloudOSSBucket]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudOSSBucketMeta.type
        name = inputData.bucket
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }

oss_provider_resources = [ commons.ResourceBuilder {
    type = alicloud_config.alicloudOSSBucketMeta.type
    name = _oss_attr.bucket
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _oss_attr
}.result for _oss_attr in alicloud.AlicloudOSSBucket.instances()]

manifests.yaml_stream(oss_provider_resources)
