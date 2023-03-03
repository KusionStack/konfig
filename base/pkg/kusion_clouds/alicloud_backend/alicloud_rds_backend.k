import base.pkg.kusion_models.commons
import .alicloud_config
import base.pkg.kusion_clouds.alicloud

schema DBInstanceRender[inputData: alicloud.AlicloudDBInstance]: 
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    data: alicloud.AlicloudDBInstance = inputData
    provider: commons.ResourceBuilder = {
        type = "alicloud_db_instance"
        name = data.instance_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = data
    }

schema DBConnectionRender[inputData: alicloud.AlicloudDBConnection]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    data: alicloud.AlicloudDBConnection = inputData
    provider: commons.ResourceBuilder = {
        type = "alicloud_db_connection"
        name = data.connection_prefix
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = data
    }

schema RDSAccountRender[inputData: alicloud.AlicloudRDSAccount, dependsOn: [str]]:
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    data: alicloud.AlicloudRDSAccount = inputData
    provider: commons.ResourceBuilder = {
        type = "alicloud_rds_account"
        name = data.account_name
        provider = alicloud_config.alicloudProvider
        providerMeta = alicloud_config.alicloudProviderMeta
        providerAttr = data
        providerDependsOn = dependsOn
    }
    