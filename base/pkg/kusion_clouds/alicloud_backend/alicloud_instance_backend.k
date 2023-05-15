import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud
import manifests

vpc_provider_resources = [ commons.ResourceBuilder {
    type = alicloud_config.alicloudVPCMeta.type
    name = _vpc_attr.vpc_name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _vpc_attr
}.result for _vpc_attr in alicloud.AlicloudVPC.instances()]

schema VPCRender[inputData: alicloud.AlicloudVPC]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudVPCMeta.type
        name = inputData.vpc_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }

vswitch_provider_resources = [commons.ResourceBuilder {
    type = alicloud_config.alicloudVswitchMeta.type
    name = _vswitch_attr.vswitch_name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _vswitch_attr
}.result for _vswitch_attr in alicloud.AlicloudVswitch.instances()]

schema VswitchRender[inputData: alicloud.AlicloudVswitch]: 
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudVswitchMeta.type
        name = inputData.vswitch_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }

security_provider_resources = [commons.ResourceBuilder {
    type = alicloud_config.alicloudSecurityGroupMeta.type
    name = _security_group_attr.name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _security_group_attr
}.result for _security_group_attr in alicloud.AlicloudSecurityGroup.instances()]

instance_provider_resources = [commons.ResourceBuilder {
    type = alicloud_config.alicloudInstanceMeta.type
    name = _instance_attr.instance_name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _instance_attr
}.result for _instance_attr in alicloud.AlicloudInstance.instances()]

# Terraform provider resources
manifests.yaml_stream(vpc_provider_resources + vswitch_provider_resources + security_provider_resources + instance_provider_resources)
