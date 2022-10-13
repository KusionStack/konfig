import base.pkg.kusion_models.kube.protocol
import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1
import base.pkg.kusion_models.kube.resource

mixin PodMonitorMixin for protocol.ServerProtocol:
    if config.enableMonitoring:
        kubernetes: resource.ResourceMapping {
            PodMonitor = [
                monitoringv1.PodMonitor {
                    metadata = workloadAttributes.metadata
                    metadata.labels: workloadAttributes.spec.template.metadata.labels
                    spec.selector.matchLabels = workloadAttributes.spec.selector.matchLabels
                    spec.podMetricsEndpoints = [
                        {
                            if p.name:
                                port = p.name
                            else:
                                targetPort = p.containerPort
                        } for p in mainContainer.ports
                    ]
                }
            ]
        }
