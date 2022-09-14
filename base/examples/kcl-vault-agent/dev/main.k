import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.serviceaccount as sa
import base.pkg.kusion_kubernetes.apimachinery.apis

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    selector = {
        "app" = "kcl-vault-agent-test"
    }
    serviceAccount: sa.ServiceAccount {
        name = "kcl-vault-agent-sa"
    }
    podMetadata = apis.ObjectMeta {
        annotations = {
            "vault.hashicorp.com/agent-inject" = "true"
            "vault.hashicorp.com/role" = "kcl-vault-agent-role"
            "vault.hashicorp.com/agent-inject-secret-database-config.txt" = "internal/data/database/config"
# following annotations are used to format output, please uncommemt those on second call of `kusion apply`
#             "vault.hashicorp.com/agent-inject-status" = "update"
#             "vault.hashicorp.com/agent-inject-template-database-config.txt" = """\
# {{- with secret "internal/data/database/config" -}}
# postgresql://{{ .Data.data.username }}:{{ .Data.data.password }}@postgres:5432/wizard
# {{- end -}}"""
        }
        labels = {
            "app" = "kcl-vault-agent-test"
        }
    }
}
