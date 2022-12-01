import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container

# application configuration
appConfiguration: frontend.Server {
    useBuiltInLabels = False
    useBuiltInSelector = False
    # main container configuration
    mainContainer = container.Main {
        name = "kcl-vault-test"
    }
    image = "jweissig/app:0.0.1"
}
