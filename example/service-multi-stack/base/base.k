import kam.v1.app_configuration as ac
import service
import service.container as c
import network as n

echoserver: ac.AppConfiguration {
    workload: service.Service {
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
    }
    accessories: {
        "network": n.Network {
            ports: [
                n.Port {
                    port: 80
                }
            ]
        }
    }
}