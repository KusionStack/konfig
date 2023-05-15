import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_kubernetes.apimachinery.apis
import base.pkg.kusion_models.kube.frontend.serviceaccount as sa
import base.pkg.kusion_models.kube.frontend.volume
import base.pkg.kusion_models.kube.metadata
import base.pkg.kusion_vault.v1 as vaultv1

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
