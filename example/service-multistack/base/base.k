import catalog.models.schema.v1 as ac
import catalog.models.schema.v1.workload as wl
import catalog.models.schema.v1.workload.network as n
import catalog.models.schema.v1.workload.container as c

echoserver: ac.AppConfiguration {
    workload: wl.Service {
        containers: {
            "server": c.Container {
                image = "<no value>"
                resources: {
                    "cpu": "250m"
                    "memory": "256Mi"
                }
            }
        }
        replicas: 1
        ports: [
            n.Port {
                port: 80
            }
        ]
    }
}