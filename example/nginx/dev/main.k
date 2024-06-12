import kam.v1.app_configuration as ac
import service
import service.container as c
import network as n

nginx: ac.AppConfiguration {
    workload: service.Service {
        containers: {
            wordpress: c.Container {
                image = "nginx:1.25.2"
                resources: {
                    "cpu": "500m"
                    "memory": "512Mi"
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
                    protocol: "TCP"
                }
            ]
        }
    }
}