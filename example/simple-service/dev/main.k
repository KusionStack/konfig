import catalog.models.schema.v1 as ac
import catalog.models.schema.v1.workload as wl
import catalog.models.schema.v1.workload.container as c
import catalog.models.schema.v1.workload.container.probe as p
import catalog.models.schema.v1.workload.network as n
import catalog.models.schema.v1.monitoring as m
import catalog.models.schema.v1.trait as t

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
        # Comment the following block to un-expose service 
        ports: [
            n.Port {
                port: 8080
                targetPort: 80
            }
        ]
    }
    # Comment the following block to remove opsRule 
    opsRule: t.OpsRule {
        maxUnavailable: "30%"
    }
    # Comment the following block to disable monitoring 
    monitoring: m.Prometheus{
        path:           "/metrics"
    }
}