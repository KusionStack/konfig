import catalog.models.schema.v1 as ac
import catalog.models.schema.v1.workload as wl
import catalog.models.schema.v1.workload.container as c

# main.k declares desired configurations for prod stack.
simplesvc: ac.AppConfiguration {
    workload: wl.Service {
        containers: {
            "nginx": c.Container {
                # use nginx:1.25.2 as target image
                image = "nginx:1.25.2"
                # resource requirements for nginx container
                resources: {
                    "cpu": "500m"
                    "memory": "512Mi"
                }
            }
        }
        replicas: 1
    }
}