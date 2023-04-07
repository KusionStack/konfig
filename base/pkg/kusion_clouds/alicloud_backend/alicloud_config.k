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

alicloudVPCMeta = {
    type = "alicloud_vpc"
}

alicloudVswitchMeta = {
    type = "alicloud_vswitch"
}

alicloudDBInstanceMeta = {
    type = "alicloud_db_instance"
}

alicloudDBConnectionMeta = {
    type = "alicloud_db_connection"
}

alicloudRDSAccountMeta = {
    type = "alicloud_rds_account"
}

alicloudOSSBucketMeta = {
    type = "alicloud_oss_bucket"
}

alicloudSecurityGroupMeta = {
    type = "alicloud_security_group"
}

alicloudInstanceMeta = {
    type = "alicloud_instance"
}
