import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.secret

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    secrets = [
        secret.Secret {
            data = {
                "ca.conf" = "ZG9tYWluSWQ9CmdhdGV3YXk9aHR0cDovL2xhYi5nYXRld2F5LmdhbGF4eS5teWJhbmsuY2"
            }
            type = "Opaque"
        }
        secret.Secret {
            data = {
                "token" = "cVZFZGowOGg1Zm5nbWlJS0FzMWw2OUhPUVdEd1pNeHo="
            }
            type = "Opaque"
        }
    ]
}
