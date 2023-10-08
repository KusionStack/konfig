import konfig.models.kube.frontend
import konfig.models.kube.frontend.container
import konfig.models.kube.templates.resource as res_tpl

# Application Configuration
appConfiguration: frontend.Server {
    schedulingStrategy.resource = res_tpl.tiny
    image = "gcr.io/google-samples/gb-frontend:v4"
}
