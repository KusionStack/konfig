import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_kubernetes.apimachinery.apis
import base.pkg.kusion_models.kube.frontend.serviceaccount as sa
import base.pkg.kusion_models.kube.frontend.volume
import base.pkg.kusion_models.kube.metadata

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    useBuiltInLabels = False
    useBuiltInSelector = False
    selector = {
        "app" = "kcl-vault-csi"
    }
    serviceAccount: sa.ServiceAccount {
        name = "kcl-vault-csi-sa"
    }
    volumes: [
        {
            name = "secrets-store-inline"
            volumeSource = volume.CSI {
                driver: "secrets-store.csi.k8s.io"
                readOnly: True
                volumeAttributes: {
                    "secretProviderClass": "kcl-vault-csi-database"
                }
            }
            mounts = [
                volume.Mount {
                    path = "/mnt/secrets-store"
                    readOnly = True
                }
            ]
        }
    ]
    podMetadata = apis.ObjectMeta {
        labels: {
            "app" = "kcl-vault-csi"
        }
    }
}

# SecretProviderClass
vaultDatabase: SecretProviderClass {
    __settings__: {
        "output_type": "STANDALONE"
    }
    metadata = apis.ObjectMeta {
        name = "kcl-vault-csi-database"
        namespace = metadata.__META_APP_NAME
    }
    spec = SecretProviderClassSpec{
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
