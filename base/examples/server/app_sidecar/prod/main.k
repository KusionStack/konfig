import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.sidecar as s
import base.pkg.kusion_models.kube.frontend.container.env as e
import base.pkg.kusion_models.kube.frontend.volume as v
import base.pkg.kusion_models.kube.templates.resource as res_tpl

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    sidecarContainers = [
        s.Sidecar {
            name = "sidecar-log-collector"
            image = "gcr.io/google_containers/fluentd-sidecar-es:1.0"
            env = [
                e.Env {
                    name = "FILES_TO_COLLECT"
                    value = "/mnt/log/synthetic-count.log /mnt/log/synthetic-dates.log"
                }
            ]
            resource = res_tpl.small
        }
    ]
    volumes = [
        v.Volume {
            name = "log-storage"
            volumeSource = v.EmptyDir {}
            mounts = [
                v.Mount {
                    container = "sidecar-log-collector"
                    path = "/mnt/log"
                    readOnly = True
                }
            ]
        }
    ]
}
