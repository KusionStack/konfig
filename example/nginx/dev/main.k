import catalog.models.schema.v1 as ac
import catalog.models.schema.v1.workload as wl
import catalog.models.schema.v1.workload.container as c
import catalog.models.schema.v1.workload.network as n

nginx: ac.AppConfiguration {
    workload: wl.Service {
        containers: {
            nginx: c.Container {
                image = "nginx:1.25.2"
                resources: {
                    "cpu": "500m"
                    "memory": "512Mi"
                }
            }
        }
        replicas: 1
        ports: [
            n.Port {
                type: "aliyun"
                port: 80
                protocol: "TCP"
                public: True
            }
        ]
    }
}