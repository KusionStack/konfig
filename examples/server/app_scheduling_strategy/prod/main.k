import konfig.models.kube.frontend
import konfig.models.kube.frontend.resource as res

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    schedulingStrategy.resource = res.Resource {
        cpu = 1
        memory = 1Gi
        disk = 30Gi
    }
}
