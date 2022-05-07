import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.secret

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    # Generate default namespace
    needNamespace = True
}
