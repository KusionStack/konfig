import konfig.models.kube.frontend
import konfig.models.kube.templates.resource as res_tpl

mw = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind = "Middleware"
    metadata = {
        name = option("app")
        namespace = option("app")
        labels = {app = option("app")}
    }
    spec = {
        basicAuth = {
            secret = option("app")
            removeHeader = True
        }
    }
}

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    schedulingStrategy.resource = res_tpl.tiny
    extraResources.mw = mw
}
