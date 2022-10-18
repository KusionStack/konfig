import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1

monitoringv1.PrometheusRule {
    metadata = {
        name = "example-alert"
        namespace = "default"
        labels: {
            "prometheus": "example"
            "role": "alert-rules"
        }
    }
    spec.groups = [
        {
            name = "alert.rules"
            rules = [
                {
                    alert: "ExampleAlert"
                    # vector(s scalar) returns the scalar s as a vector with no labels.
                    expr: "vector(1)"
                }
            ]
        }
    ]
}