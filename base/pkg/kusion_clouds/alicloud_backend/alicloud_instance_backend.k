import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud

_vpc_attrs = alicloud.AlicloudVPC.instances()

vpc_provider = [ commons.ResourceBuilder {
    type = alicloud_config.alicloudVPCMeta.type
    name = _vpc_attr.vpc_name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _vpc_attr
} for _vpc_attr in _vpc_attrs ]

schema VPCRender[inputData: alicloud.AlicloudVPC]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudVPCMeta.type
        name = inputData.vpc_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }
    
_vswitch_attrs = alicloud.AlicloudVswitch.instances()

vswitch_provider = [commons.ResourceBuilder {
    type = alicloud_config.alicloudVswitchMeta.type
    name = _vswitch_attr.vswitch_name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _vswitch_attr
} for _vswitch_attr in _vswitch_attrs]

schema VswitchRender[inputData: alicloud.AlicloudVswitch]: 
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudVswitchMeta.type
        name = inputData.vswitch_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }

_security_group_attrs = alicloud.AlicloudSecurityGroup.instances()

security_provider = [commons.ResourceBuilder {
    type = alicloud_config.alicloudSecurityGroupMeta.type
    name = _security_group_attr.name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _security_group_attr
} for _security_group_attr in _security_group_attrs ]

_instance_attrs = alicloud.AlicloudInstance.instances()

instance_provider = [commons.ResourceBuilder {
    type = alicloud_config.alicloudInstanceMeta.type
    name = _instance_attr.instance_name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _instance_attr
} for _instance_attr in _instance_attrs]
