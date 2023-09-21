import catalog.models.schema.v1 as ac

# platform.k declares customized configurations 
wordpress: ac.AppConfiguration {
    database: {
        category = "serverless_basic"
        # SubnetID defines the virtual subnet ID associated with the VPC that the rds
        # instance will be created in. The rds instance won't be created in user's own VPC
        # if this field is not provided.
        subnetID = [your-subnet-id] 
        securityIPs = ["0.0.0.0/0"]
        privateRouting = False
    }
}
