import base.pkg.kusion_kubernetes.api.core.v1 as corev1
import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1
import base.pkg.kusion_prometheus.monitoring.v1alpha1 as monitoringv1alpha1


# 1. creates an AlertmanagerConfig that sends notifications to a fictitious webhook service.
_alertmanager_config: monitoringv1alpha1.AlertmanagerConfig{
    metadata = {
        name = "config-example"
        namespace = _common_namespace
        labels = {
            "alertmanagerConfig" = "example"
        }
    }
    spec = {
        route = {
            groupBy = ["job"]
            groupWait = "30s"
            groupInterval = "5m"
            repeatInterval = "12h"
            receiver = "webhook"
        }
        receivers = [
            {
                name = "webhook"
                webhookConfigs = [
                    {
                        url = "http://example.com/"
                    }
                ]
            }
        ]
    }
}

# 2. create an alertmanager cluster with 3 replicas and configured with alertmanager config
_alertmanager: monitoringv1.Alertmanager{
    metadata = {
        name = "example"
        namespace = _common_namespace
    }
    spec = {
        replicas = 3
        # using AlertmanagerConfig for global configuration
        alertmanagerConfiguration = {
            name = _alertmanager_config.metadata.name
        }
    }
}

# 3. expose alertmanager service
_alertmanager_svc: corev1.Service{
    metadata = {
        name = "alertmanager-example"
        namespace = _common_namespace
    }
    spec = {
        selector = {
            "alertmanager" = _alertmanager.metadata.name
        }
        ports = [
            {
                name = "web"
                port = 9093
                targetPort = "web"
            }
            {
                name = "reloader-web"
                port = 8080
                targetPort = "reloader-web"
            }
        ]
        sessionAffinity = "ClientIP"
    }
}

# 4. create a prometheus instance, intergated with alertmanager cluster
_prometheus: monitoringv1.Prometheus{
    metadata = {
        name = "example"
        namespace = _common_namespace
    }
    spec = {
        # specify service account, default sa has no permissions
        serviceAccountName = _rbac_name
        replicas = 1
        # ruleSelector is nil meaning that the operator picks up no rule
        ruleSelector = {
            matchLabels = {
                "role" = "alert-rules"
                "prometheus" = "example"
            }
        }
        serviceMonitorSelector = {
            matchLabels = {
                "prometheus" = "example"
            }
        }
        # intergating with alert manager by its service
        alerting = {
            alertmanagers = [
                {
                    name = _alertmanager_svc.metadata.name
                    namespace = _alertmanager_svc.metadata.namespace
                    port = _alertmanager_svc.spec.ports[0].name
                }
            ]
        }
    }
}

# 5. expose prometheus service
_prometheus_svc: corev1.Service{
    metadata = {
        name = "prometheus-example"
        namespace = _common_namespace
    }
    spec = {
        selector = {
            "prometheus" = _prometheus.metadata.name
        }
        ports = [
            {
                name = "web"
                port = 9090
                targetPort = "web"
            }
            {
                name = "reloader-web"
                port = 8080
                targetPort = "reloader-web"
            }
        ]
        sessionAffinity = "ClientIP"
    }
}