import base.pkg.kusion_models.kube.frontend

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    # spec.template.spec.containers[0], main container
    image = "altinity/clickhouse-operator:0.19.2"

    # spec.template.spec.containers[1:], sidecars
    sidecarContainers = [
        s.Sidecar {
            name = "metrics-exporter"
            image = "altinity/metrics-exporter:0.19.2"
            resource = ""
        }
    ]
}
