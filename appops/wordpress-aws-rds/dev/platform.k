import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.storage
import base.pkg.kusion_models.kube.metadata
import base.pkg.kusion_clouds.aws_backend.aws_config

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
# And platform.k is for the configurations in concern of platform developers. 

_cloudResourceName = "{}-{}".format(metadata.__META_APP_NAME, metadata.__META_ENV_TYPE_NAME).lower()
_awsDependencyPrefix = "$kusion_path." + aws_config.awsProvider.namespace + ":" + aws_config.awsProvider.name + ":"

# defination of wordpress application frontend model
wordpress: frontend.Server {
    # add environment variable in main container with implicit alicloud resource dependency
    mainContainer: {
        env += [
            {
                name = "WORDPRESS_DB_HOST"
                value = _awsDependencyPrefix + aws_config.awsDBInstanceMeta.type + ":" + _cloudResourceName + ".address"
            }
        ]
    }

    # supplement database related configuration code on the platform side
    database: storage.DataBase {
        dataBaseAttr: storage.DBAttr {
            # specify instance type for aws or alicloud rds
            # for aws rds
            instanceType = "db.t3.micro" 

            # for alicloud rds
            # instanceType = "mysql.n2.serverless.1c" 

            # specify cloud charge type for alicloud rds
            # extraMap = {
            #     "cloudChargeType": "Serverless"
            # }
        }
    }
}
