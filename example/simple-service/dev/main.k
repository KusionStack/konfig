import kam.v1.app_configuration as ac
import kam.v1.workload as wl
import kam.v1.workload.container as c
import kam.v1.workload.container.probe as p
import monitoring as m
import opsrule as o
import network as n

helloworld: ac.AppConfiguration {
    workload: wl.Service {
        containers: {
            "helloworld": c.Container {
                image: "gcr.io/google-samples/gb-frontend:v4"
                env: {
                    "env1": "VALUE"
                    "env2": "VALUE2"
                }
                resources: {
                    "cpu": "500m"
                    "memory": "512M"
                }
                # Configure an HTTP readiness probe
                readinessProbe: p.Probe {
                    probeHandler: p.Http {
                        url: "http://localhost:80"
                    }
                    initialDelaySeconds: 10
                }
            }
        }
        replicas: 2
    }
    accessories: {
        "network": n.Network {
            ports: [
                n.Port {
                    port: 8080
                    targetPort: 80
                }
            ]
        }
        "monitoring": m.Prometheus {
            path:           "/metrics"
        }
        "opsRule": o.OpsRule {
            maxUnavailable: "30%"
        }
    }
}