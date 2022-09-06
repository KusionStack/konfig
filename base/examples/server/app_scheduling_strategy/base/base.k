import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container

# Application Configuration
appConfiguration: frontend.Server {
    # Main Container Configuration
    mainContainer = container.Main {}
    image = "gcr.io/google-samples/gb-frontend:v4"
}
