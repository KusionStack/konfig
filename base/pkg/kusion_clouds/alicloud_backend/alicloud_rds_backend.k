import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud

schema DBInstanceRender[inputData: alicloud.AlicloudDBInstance]: 
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudDBInstanceMeta.type
        name = inputData.instance_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }

schema DBConnectionRender[inputData: alicloud.AlicloudDBConnection]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudDBConnectionMeta.type
        name = inputData.connection_prefix
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
    }

schema RDSAccountRender[inputData: alicloud.AlicloudRDSAccount, dependsOn: [str]]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = alicloud_config.alicloudRDSAccountMeta.type
        name = inputData.account_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = inputData
        providerDependsOn = dependsOn
    }
