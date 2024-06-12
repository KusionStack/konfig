import kam.v1.app_configuration as ac
import service
import service.container as c

# main.k declares customized configurations for prod stack.
echoserver: ac.AppConfiguration {
    workload: service.Service {
        containers: {
            "server": c.Container {
                # prod stack use older stable echoserver image
                image = "cilium/echoserver:1.10.3"
                # also prod stack require more resources
                resources: {
                    "cpu" = "500m"
                    "memory" = "512Mi"
                }
            }
        }
        # replicas is 2 for prod
        replicas = 2
    }
}