import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_kubernetes.apimachinery.apis

# application configuration
appConfiguration: frontend.Server {
    # main container configuration
    mainContainer = container.Main {
        name = "kcl-vault-csi"
    }
    image = "jweissig/app:0.0.1"
}

# SecretProviderClass
vaultDatabase: vaultv1.SecretProviderClass {
    metadata = apis.ObjectMeta {
        name = "kcl-vault-csi-database"
        namespace = metadata.__META_APP_NAME
    }
    spec = vaultv1.SecretProviderClassSpec {
        provider = "vault"
        parameters = {
            "vaultAddress": "http://vault.default:8200"
            "roleName": "kcl-vault-csi-role"
            "objects": """\
- objectName: "db-password"
  secretPath: "secret/data/db-pass"
  secretKey: "password"
"""
        }
    }
}
