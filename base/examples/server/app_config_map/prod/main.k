import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.configmap

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    configMaps = [
        configmap.ConfigMap {
            data = {
                "app.name" = __META_APP_NAME
            }
        }
        configmap.ConfigMap {
            data = {
                "nginx.conf" = "configuration_content"
            }
        }
    ]
}
