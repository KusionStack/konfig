import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1

monitoringv1.PrometheusRule {
    metadata = {
        name = "alert"
        namespace = "default"
        labels: {
            "prometheus": "main"
            "role": "alert-rules"
        }
    }
    spec.groups = [
        {
            name = "alert.rules"
            rules = [
                {
                    alert: "WebhookAlert"
                    # vector(s scalar) returns the scalar s as a vector with no labels.
                    expr: "vector(1)"
                }
            ]
        }
    ]
}