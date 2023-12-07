import catalog.models.schema.v1 as ac

# main.k declares customized configurations for prod stack.
echoserver: ac.AppConfiguration {
    # replicas is 2 for prod
    workload.replicas = 2
    workload.containers.server: {
        # prod stack use older stable echoserver image
        image = "cilium/echoserver:1.10.3"
        # also prod stack require more resources
        resources = {
            "cpu": "500m"
            "memory": "512Mi"
        }
    }
}