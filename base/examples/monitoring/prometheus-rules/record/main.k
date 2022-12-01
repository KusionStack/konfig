import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1

# expr: sum of node available memory in bytes
_sum_of_node_memory = """\
sum(
  node_memory_MemAvailable_bytes{job="node-exporter"} or
  (
    node_memory_Buffers_bytes{job="node-exporter"} +
    node_memory_Cached_bytes{job="node-exporter"} +
    node_memory_MemFree_bytes{job="node-exporter"} +
    node_memory_Slab_bytes{job="node-exporter"}
  )
) by (cluster)
"""

# expr: calculates the average rate of increase of node cpu every 5 minutes
_node_cpu = """\
sum(rate(node_cpu_seconds_total{job="node-exporter",mode!="idle",mode!="iowait",mode!="steal"}[5m])) /
count(sum(node_cpu_seconds_total{job="node-exporter"}) by (cluster, instance, cpu))
"""

monitoringv1.PrometheusRule {
    metadata = {
        name = "k8s-rules"
        namespace = "default"
        labels: {
            "prometheus": "main"
            "role": "alert-rules"
        }
    }
    spec.groups = [
        {
            name = "node.rules"
            rules = [
                {
                    expr = _sum_of_node_memory
                    record = ":node_memory_MemAvailable_bytes:sum"
                }
                {
                    expr = _node_cpu
                    record = "cluster:node_cpu:ratio_rate5m"
                }
            ]
        }
    ]
}
