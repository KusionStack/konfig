import konfig.models.kube.frontend
import konfig.models.kube.templates.resource as res_tpl

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    schedulingStrategy.resource = res_tpl.tiny
}
