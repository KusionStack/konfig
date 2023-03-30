import base.pkg.kusion_models.kube.frontend

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.

# defination of wordpress application frontend model
wordpress = frontend.Server {
    # specify application image
    image = "wordpress:4.8-apache"
    # render the k8s resources in the form of KubeVela Application
    renderType = "KubeVelaApplication"

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
            databaseAccountPassword = "Kusion123456"
            # create internet access for the cloud database
            internetAccess = True
        }
    }
}
