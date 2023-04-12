import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.storage

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
# And main.k is for the configurations in concern of application developers. 

# defination of wordpress application frontend model
wordpress: frontend.Server {
    # specify application image
    image = "wordpress:4.8-apache"

    # use cloud database for the storage of wordpress
    database = storage.DataBase {
        # choose aliyun_rds as the cloud database
        dataBaseType = "aliyun_rds"
        dataBaseAttr = storage.DBAttr {
            # choose the engine type and version of the database
            databaseEngine = "MySQL"
            databaseEngineVersion = "5.7"
            # choose the charge type of the cloud database
            cloudChargeType = "Serverless"
            # create database account
            databaseAccountName = "root"
            databaseAccountPassword = option("db_password")
            # create internet access for the cloud database
            internetAccess = True
        }
    }

    mainContainer: {
        env += [
            {
                name = "ENV_ADD_EXAMPLE"
                value = "wordpress-example"
            }
        ]
    }
}
