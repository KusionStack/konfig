import konfig.models.kube.frontend
import konfig.models.kube.frontend.service

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    services = [
        service.Service {
            name = "frontend"
            type = "NodePort"
            ports = [
                {
                    "port" = 80
                }
            ]
        }
    ]
}
