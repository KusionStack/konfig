import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.templates.resource as res_tpl

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
guestbookFrontend: frontend.Server {
    image = "gcr.io/google-samples/gb-frontend:v4"
}
