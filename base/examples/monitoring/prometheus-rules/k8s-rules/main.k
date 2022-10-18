import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1
import .rules

k8s_rules: monitoringv1.PrometheusRule {
    metadata = {
        name = "kubernetes-monitoring-rules"
        namespace = "default"
        labels: {
            "prometheus": "example",
            "role": "alert-rules",
        }
    }
    spec = {
        groups = [
            rules.kubelet_rules,
            rules.node_rules
        ]
    }
}
