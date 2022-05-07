import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.templates.resource as res_tpl
import base.pkg.kusion_models.kube.frontend.service
import base.pkg.kusion_models.kube.frontend.ingress

# application configuration
appConfiguration: frontend.Server {
    # main container configuration
    mainContainer = container.Main {
        name = "kcl-vault-test"
    }
    image = "jweissig/app:0.0.1"
}
