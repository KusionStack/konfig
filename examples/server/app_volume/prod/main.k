import konfig.models.kube.frontend
import konfig.models.kube.frontend.volume as v

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
