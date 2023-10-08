import konfig.models.kube.frontend
import konfig.models.kube.frontend.configmap

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    configMaps = [
        configmap.ConfigMap {
            data = {
                "app.name" = "app_config_map"
            }
        }
        configmap.ConfigMap {
            data = {
                "nginx.conf" = "configuration_content"
            }
        }
    ]
}
