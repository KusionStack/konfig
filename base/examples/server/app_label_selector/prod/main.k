import base.pkg.kusion_models.kube.frontend

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    # Custom workload selector
    selector: {
        "app.kubernetes.io/version" = "v1.0.0"
    }
    # Custom workload pod metadata
    podMetadata: {
        labels: {
            "app.kubernetes.io/version" = "v1.0.0"
        }
        annotations: {
            "owner" = "team-iac"
        }
    }
}
