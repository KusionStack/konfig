import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud


_vpc_attrs = alicloud.AlicloudVPC.instances()

vpc_provider = [ commons.ResourceBuilder {
    type = "alicloud_vpc"
    name = _vpc_attr.name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _vpc_attr
} for _vpc_attr in _vpc_attrs ]

_vswitch_attrs = alicloud.AlicloudVswitch.instances()

vswitch_provider = [commons.ResourceBuilder {
    type = "alicloud_vswitch"
    name = _vswitch_attr.name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _vswitch_attr
} for _vswitch_attr in _vswitch_attrs]

_kubernetes_instances = alicloud.AlicloudManagedKubernetes.instances()

managed_kubernetes_provider = [ commons.ResourceBuilder {
    type = "alicloud_cs_managed_kubernetes"
    name = _kubernetes.name
    provider = alicloud_config.alicloudProvider
    providerMeta = alicloud_config.alicloudProviderMeta
    providerAttr = _kubernetes
} for _kubernetes in _kubernetes_instances ]