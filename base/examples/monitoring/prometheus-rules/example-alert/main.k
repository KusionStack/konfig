import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1

alerts: monitoringv1.PrometheusRule {
    metadata = {
        name = "example-alert"
        namespace = "default"
        labels: {
            "prometheus": "example",
            "role": "alert-rules",
        }
    }
    spec = {
        groups = [
            {
                name = "./example.rules"
                rules = [
                    {
                        alert: "ExampleAlert"
                        expr: "vector(1)"
                    }
                ]
            }
        ]
    }
}