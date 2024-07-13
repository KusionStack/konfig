import konfig.models.kube.frontend
import konfig.models.kube.frontend.rbac
import konfig.models.kube.frontend.volume as v

rbac.ClusterRole {
    metadata.name = "my-rule"
    rules = [{
        apiGroups = ["v1"]
        verbs = ["*"]
    }]
}

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    volumes = [
        v.Volume {
            name = "log-volume"
            volumeSource = v.EmptyDir {}
            mounts = [
                v.Mount {
                    container = "main"
                    path = "/home/admin/logs"
                }
            ]
        }
    ]
}
