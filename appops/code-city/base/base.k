import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.service
import base.pkg.kusion_models.kube.frontend.container

# Application Configuration
appConfiguration: frontend.Server {
    # Main Container Configuration
    mainContainer = container.Main {
        name = "gocity"
        ports = [
            { containerPort = 4000 }
        ]
    }

    useBuiltInSelector = False
    selector: {
        "app.kubernetes.io/name" = "gocity"
        "app.kubernetes.io/env" = "dev"
    }

    useBuiltInLabels = False
    podMetadata.labels: {
        "app.kubernetes.io/name" = "gocity"
        "app.kubernetes.io/env" = "dev"
    }

    services = [
        service.Service {
            name = "gocity"
            type = "ClusterIP"
            ports = [
                {
                    name = "{}-backend".format("gocity")
                    port = 4000
                    targetPort = 4000
                    protocol = "TCP"
                }
            ]
        }
    ]
}