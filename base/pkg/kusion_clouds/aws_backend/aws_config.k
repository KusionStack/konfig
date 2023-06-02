import base.pkg.kusion_models.commons

awsProvider = commons.Provider {
    host = "registry.terraform.io"
    namespace = "hashicorp"
    name = "aws"
    version = "5.0.1"
}

awsProviderMeta = {
    region = "us-east-1"
    access_key       = option("alicloud-ak") or Undefined
    secret_key       = option("alicloud-sk") or Undefined
}

awsSecurityGroupMeta = {
    type = "aws_security_group"
}

awsDBInstanceMeta = {
    type = "aws_db_instance"
}
