import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.templates.resource as res_tpl
import base.pkg.kusion_models.kube.frontend.volume as v

# Application Configuration
appConfiguration: frontend.Server {
    schedulingStrategy.resource = res_tpl.tiny
    image = "gcr.io/google-samples/gb-frontend:v4"
}
