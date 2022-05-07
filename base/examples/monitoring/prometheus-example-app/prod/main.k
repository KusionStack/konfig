import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.frontend.container.env as e
import base.pkg.kusion_models.kube.frontend.container.port as cp
import base.pkg.kusion_models.kube.frontend.container.probe as p

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    # Main container configuration
    mainContainer: container.Main {
        name = "prometheus-example-app"
        ports = [
            cp.ContainerPort {
                name = "web"
                containerPort = 8080
            }
        ]
    }
    enableMonitoring = True
}
