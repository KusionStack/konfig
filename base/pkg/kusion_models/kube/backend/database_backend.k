import base.pkg.kusion_models.kube.metadata
import base.pkg.kusion_models.kube.frontend.server
import base.pkg.kusion_clouds.alicloud
import base.pkg.kusion_clouds.alicloud_backend
import base.pkg.kusion_clouds.alicloud_backend.alicloud_config
import base.pkg.kusion_clouds.aws
import base.pkg.kusion_clouds.aws_backend
import base.pkg.kusion_clouds.aws_backend.aws_config

_cloudResourceName = "{}-{}".format(metadata.__META_APP_NAME, metadata.__META_ENV_TYPE_NAME).lower()
_alicloudDependencyPrefix = "$kusion_path." + alicloud_config.alicloudProvider.namespace + ":" + alicloud_config.alicloudProvider.name + ":"
_awsDependencyPrefix = "$kusion_path." + aws_config.awsProvider.namespace + ":" + aws_config.awsProvider.name + ":"
_awsInstanceTypeList = ["db.t3.micro", "db.t3.small", "db.t3.medium", "db.t3.large", "db.t3.xlarge", "db.t3.2xlarge"]

schema DatabaseBackend[config: server.Server]: 
    assert config, "input config must be specified and can't be empty or None or Undefined"
    provider: [any]

    if config.database: 
        if config.database.dataBaseType == "aws_rds": 
            assert config.database.dataBaseAttr.instanceType in _awsInstanceTypeList, "invalid AWS RDS instance type "
            awsSecurityGroup = aws.AWSSecurityGroup {
                name = _cloudResourceName
                ingress = [{
                    from_port = 3306
                    to_port = 3306
                    protocol = "tcp"
                    cidr_blocks = ["0.0.0.0/0"]
                    description = ""
                    ipv6_cidr_blocks = None
                    prefix_list_ids = None
                    security_groups = None
                    self = False
                }]
                egress = [{
                    from_port = 0
                    to_port = 0
                    protocol = "-1"
                    cidr_blocks = ["0.0.0.0/0"]
                    description = ""
                    self = False
                    ipv6_cidr_blocks = None
                    prefix_list_ids = None
                    security_groups = None
                }]
            }
            provider = [*provider, aws_backend.SecurityGroupRender(awsSecurityGroup).provider]

            awsDBInstance = aws.AWSDBInstance {
                engine = config.database.dataBaseAttr.databaseEngine
                engine_version = config.database.dataBaseAttr.databaseEngineVersion
                identifier = _cloudResourceName
                allocated_storage = config.database.dataBaseAttr.allocatedStorage
                instance_class = config.database.dataBaseAttr.instanceType
                username = config.database.dataBaseAttr.databaseAccountName
                password = config.database.dataBaseAttr.databaseAccountPassword
                vpc_security_group_ids = [_awsDependencyPrefix + aws_config.awsSecurityGroupMeta.type + ":" + awsSecurityGroup.name + ".id"]
                skip_final_snapshot = True
                publicly_accessible = config.database.dataBaseAttr.internetAccess
            }
            provider = [*provider, aws_backend.DBInstanceRender(awsDBInstance).provider]

        if config.database.dataBaseType == "aliyun_rds": 
            aliyunVPC = alicloud.AlicloudVPC {
                vpc_name = _cloudResourceName
            }
            provider = [*provider, alicloud_backend.VPCRender(aliyunVPC).provider] 
            
            aliyunVswitch = alicloud.AlicloudVswitch {
                vpc_id = _alicloudDependencyPrefix + alicloud_config.alicloudVPCMeta.type + ":" + aliyunVPC.vpc_name + ".id"
                vswitch_name = _cloudResourceName
                zone_id = alicloud_config.alicloudProviderMeta.region + "-h"
            }
            provider = [*provider, alicloud_backend.VswitchRender(aliyunVswitch).provider]

            if config.database.dataBaseAttr.extraMap?["cloudChargeType"] == "Serverless": 
                assert config.database.dataBaseAttr.databaseEngine == "MySQL", "databaseEngine must be set to MySQL when creating a serverless instance"
                aliyunDBInstance = alicloud.AlicloudDBInstance {
                    engine = config.database.dataBaseAttr.databaseEngine
                    engine_version = config.database.dataBaseAttr.databaseEngineVersion
                    instance_type = config.database.dataBaseAttr.instanceType
                    instance_charge_type = config.database.dataBaseAttr.extraMap["cloudChargeType"]
                    instance_name = _cloudResourceName
                    vswitch_id = _alicloudDependencyPrefix + alicloud_config.alicloudVswitchMeta.type + ":" + aliyunVswitch.vswitch_name + ".id"
                    category = "serverless_basic"
                    security_ips = ["0.0.0.0/0"]
                    serverless_config = [alicloud.serverlessConfig{}]
                }
                provider = [*provider, alicloud_backend.DBInstanceRender(aliyunDBInstance).provider]

                if config.database.dataBaseAttr.internetAccess: 
                    aliyunDBConnection = alicloud.AlicloudDBConnection {
                        instance_id = _alicloudDependencyPrefix + alicloud_config.alicloudDBInstanceMeta.type + ":" + aliyunDBInstance.instance_name + ".id"
                        connection_prefix = _cloudResourceName
                    }
                    provider = [*provider, alicloud_backend.DBConnectionRender(aliyunDBConnection).provider]

                    aliyunRDSAccount = alicloud.AlicloudRDSAccount {
                        db_instance_id = _alicloudDependencyPrefix + alicloud_config.alicloudDBInstanceMeta.type + ":" + aliyunDBInstance.instance_name + ".id"
                        account_name = config.database.dataBaseAttr.databaseAccountName
                        account_password = config.database.dataBaseAttr.databaseAccountPassword
                        account_type = "Super"
                    }
                    provider = [*provider, alicloud_backend.RDSAccountRender(aliyunRDSAccount, ["aliyun:alicloud:alicloud_db_connection:"+aliyunDBConnection.connection_prefix]).provider]
                else: 
                    aliyunRDSAccount = alicloud.AlicloudRDSAccount {
                        db_instance_id = _alicloudDependencyPrefix + alicloud_config.alicloudDBInstanceMeta.type + ":" + aliyunDBInstance.instance_name + ".id"
                        account_name = config.database.dataBaseAttr.databaseAccountName
                        account_password = config.database.dataBaseAttr.databaseAccountPassword
                        account_type = "Super"
                    }
                    provider = [*provider, alicloud_backend.RDSAccountRender(aliyunRDSAccount).provider]