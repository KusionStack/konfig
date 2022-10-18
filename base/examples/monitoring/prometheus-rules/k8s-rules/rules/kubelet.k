import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1

kubelet_rules = monitoringv1.RuleGroup{
    name = "kubelet.rules"
    rules = [
        {
            expr = "histogram_quantile(" + quantile + ", sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m])) by (cluster, instance, le) * on(cluster, instance) group_left(node) kubelet_node_name{job=\"kubelet\"})"
            labels = {
                "quantile": quantile
            }
            record = "node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile"
        } for quantile in ["0.99", "0.9", "0.5"]
    ]
}
