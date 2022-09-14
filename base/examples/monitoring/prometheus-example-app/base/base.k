import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.templates.resource as res_tpl

# Application Configuration
appConfiguration: frontend.Server {
    schedulingStrategy.resource = res_tpl.tiny
    # Ref: https://github.com/brancz/prometheus-example-app/blob/master/main.go
    image = "quay.io/brancz/prometheus-example-app:v0.3.0"
}
