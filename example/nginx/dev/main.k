import kam.v1.app_configuration as ac
import kam.v1.workload as wl
import kam.v1.workload.container as c
import network as n

nginx: ac.AppConfiguration {
    workload: wl.Service {
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
                    public: True
                }
            ]
        }
    }
}