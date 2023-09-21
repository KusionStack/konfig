import catalog.models.schema.v1 as ac

# main.k declares customized configurations for dev stack.
helloworld: ac.AppConfiguration {
    workload.replicas = 2
    workload.containers.helloworld: {
        # dev stack has different app configuration
        image = "gcr.io/google-samples/gb-frontend:v5"
        resources = {
            "cpu": "250m"
            "memory": "256Mi"
        }
    }
}