import base.pkg.kusion_models.kube.metadata
import base.pkg.kusion_models.kube.protocol
import base.pkg.kusion_models.kube.resource
import base.pkg.kusion_models.kube.utils
import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1

mixin MonitorMixin for protocol.ServerProtocol:
    # enable prometheus monitoring
    if config.enableMonitoring:
        # generate ServiceMonitor if service is configured
        if config.services:
            kubernetes: resource.ResourceMapping {
                ServiceMonitor = [
                    monitoringv1.ServiceMonitor {
                        metadata: utils.MetadataBuilder(_s) | {
                            name = _s?.name or "{}-{}-{}".format(metadata.__META_APP_NAME, metadata.__META_ENV_TYPE_NAME, _i)
                        }
                        spec.selector.matchLabels = _s?.selector or workloadAttributes?.spec?.selector?.matchLabels
                        # set endpoints with ServicePort
                        spec.endpoints = [
                            {
                                if p.name:
                                    port = p.name
                                else:
                                    targetPort = p.port
                            } for p in _s?.ports
                        ]
                    } for _i, _s in config.services
                ]
            }
        # else use PodMointor
        else:
            kubernetes: resource.ResourceMapping {
                PodMonitor = [
                    monitoringv1.PodMonitor {
                        metadata = workloadAttributes.metadata
                        metadata.labels: workloadAttributes.spec.template.metadata.labels
                        spec.selector.matchLabels = workloadAttributes.spec.selector.matchLabels
                        # set endpoints with containerPort
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
