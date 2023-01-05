import base.pkg.kusion_kubernetes.apimachinery.apis
import base.pkg.kusion_kubernetes.api.core.v1 as corev1
import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.configmap
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.frontend.container.env as e
import base.pkg.kusion_models.kube.frontend.service
import base.pkg.kusion_models.kube.frontend.serviceaccount as sa
import base.pkg.kusion_models.kube.frontend.sidecar as s
import base.pkg.kusion_models.kube.frontend.volume
import base.pkg.kusion_models.kube.metadata
import .templates

_app_release_version = "0.19.2"

appConfiguration: frontend.Server {
    # metadata.labels
    useBuiltInLabels = False
    labels = {
        "clickhouse.altinity.com/chop" = _app_release_version
        "app" = metadata.__META_APP_NAME
    }

    # spec.selector
    useBuiltInSelector = False
    selector = {
        "app" = metadata.__META_APP_NAME
    }

    # spec.template.metadata
    podMetadata = apis.ObjectMeta {
        labels = {
            "app" = metadata.__META_APP_NAME
        }
        annotations = {
            "prometheus.io/port" = "8888"
            "prometheus.io/scrape" = "true"
        }
    }

    # spec.template.spec.containers[0], main container
    image = "altinity/clickhouse-operator:0.19.2"
    schedulingStrategy.resource = Undefined
    mainContainer = container.Main {
        name = metadata.__META_APP_NAME
        env = [
            e.Env {
                name = "OPERATOR_POD_NODE_NAME"
                valueFrom = e.EnvValueFrom {
                    fieldRef = e.ObjectFieldSelector {
                        fieldPath = "spec.nodeName"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_POD_NAME"
                valueFrom = e.EnvValueFrom {
                    fieldRef = e.ObjectFieldSelector {
                        fieldPath = "metadata.name"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_POD_NAMESPACE"
                valueFrom = e.EnvValueFrom {
                    fieldRef = e.ObjectFieldSelector {
                        fieldPath = "metadata.namespace"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_POD_IP"
                valueFrom = e.EnvValueFrom {
                    fieldRef = e.ObjectFieldSelector {
                        fieldPath = "status.podIP"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_POD_SERVICE_ACCOUNT"
                valueFrom = e.EnvValueFrom {
                    fieldRef = e.ObjectFieldSelector {
                        fieldPath = "spec.serviceAccountName"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_CONTAINER_CPU_REQUEST"
                valueFrom = e.EnvValueFrom {
                    resourceFieldRef = e.ResourceFieldSelector {
                        containerName = "clickhouse-operator"
                        resource = "requests.cpu"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_CONTAINER_CPU_LIMIT"
                valueFrom = e.EnvValueFrom {
                    resourceFieldRef = e.ResourceFieldSelector {
                        containerName = "clickhouse-operator"
                        resource = "limits.cpu"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_CONTAINER_MEM_REQUEST"
                valueFrom = e.EnvValueFrom {
                    resourceFieldRef = e.ResourceFieldSelector {
                        containerName = "clickhouse-operator"
                        resource = "requests.memory"
                    }
                }
            }
            e.Env {
                name = "OPERATOR_CONTAINER_MEM_LIMIT"
                valueFrom = e.EnvValueFrom {
                    resourceFieldRef = e.ResourceFieldSelector {
                        containerName = "clickhouse-operator"
                        resource = "limits.memory"
                    }
                }
            }
        ]
    }

    # spec.template.spec.containers[1:], other containers
    sidecarContainers = [
        s.Sidecar {
            name = "metrics-exporter"
            image = "altinity/metrics-exporter:0.19.2"
            resource = ""
        }
    ]

    # spec.template.spec.volumes
    volumes = [
        volume.Volume {
            name = "etc-clickhouse-operator-folder"
            volumeSource = volume.ConfigMap {
                name = "etc-clickhouse-operator-files"
            }
            mounts = [
                volume.Mount {
                    path = "/etc/clickhouse-operator"
                }
            ]
        }
        volume.Volume {
            name = "etc-clickhouse-operator-confd-folder"
            volumeSource = volume.ConfigMap {
                name = "etc-clickhouse-operator-confd-files"
            }
            mounts = [
                volume.Mount {
                    path = "/etc/clickhouse-operator/conf.d"
                }
            ]
        }
        volume.Volume {
            name = "etc-clickhouse-operator-configd-folder"
            volumeSource = volume.ConfigMap {
                name = "etc-clickhouse-operator-configd-files"
            }
            mounts = [
                volume.Mount {
                    path = "/etc/clickhouse-operator/config.d"
                }
            ]
        }
        volume.Volume {
            name = "etc-clickhouse-operator-templatesd-folder"
            volumeSource = volume.ConfigMap {
                name = "etc-clickhouse-operator-templatesd-files"
            }
            mounts = [
                volume.Mount {
                    path = "/etc/clickhouse-operator/templates.d"
                }
            ]
        }
        volume.Volume {
            name = "etc-clickhouse-operator-usersd-folder"
            volumeSource = volume.ConfigMap {
                name = "etc-clickhouse-operator-usersd-files"
            }
            mounts = [
                volume.Mount {
                    path = "/etc/clickhouse-operator/users.d"
                }
            ]
        }
    ]

    # related serviceaccout
    serviceAccount = sa.ServiceAccount {
        name = metadata.__META_APP_NAME
        labels = {
            "clickhouse.altinity.com/chop" = _app_release_version
        }
    }

    # related configmap
    configMaps = [
        configmap.ConfigMap {
            name = "etc-clickhouse-operator-files"
            labels = {
                "clickhouse.altinity.com/chop" = _app_release_version
                "app" = metadata.__META_APP_NAME
            }
            data = {
                "config.yaml" = templates.config_yaml
            }
        }
        configmap.ConfigMap {
            name = "etc-clickhouse-operator-confd-files"
            labels = {
                "clickhouse.altinity.com/chop" = _app_release_version
                "app" = metadata.__META_APP_NAME
            }
        }
        configmap.ConfigMap {
            name = "etc-clickhouse-operator-configd-files"
            labels = {
                "clickhouse.altinity.com/chop" = _app_release_version
                "app" = metadata.__META_APP_NAME
            }
            data = {
                "01-clickhouse-01-listen.xml" = templates.clickhouse_01_listen_xml
                "01-clickhouse-02-logger.xml" = templates.clickhouse_02_logger_xml
                "01-clickhouse-03-query_log.xml" = templates.clickhouse_03_query_log_xml
                "01-clickhouse-04-part_log.xml" = templates.clickhouse_04_part_log_xml
            }
        }
        configmap.ConfigMap {
            name = "etc-clickhouse-operator-templatesd-files"
            labels = {
                "clickhouse.altinity.com/chop" = _app_release_version
                "app" = metadata.__META_APP_NAME
            }
            data = {
                "001-templates.json.example" = templates.templates_json_example
                "default-pod-template.yaml.example" = templates.default_pod_template_yaml_example
                "default-storage-template.yaml.example" = templates.default_storage_template_yaml_example
                "readme" = templates.readme
            }
        }
        configmap.ConfigMap {
            name = "etc-clickhouse-operator-usersd-files"
            labels = {
                "clickhouse.altinity.com/chop" = _app_release_version
                "app" = metadata.__META_APP_NAME
            }
            data = {
                "01-clickhouse-user.xml" = templates.clickhouse_user_xml
                "02-clickhouse-default-profile.xml" = templates.clickhouse_default_profile_xml
                "03-database-ordinary.xml" = templates.database_ordinary_xml
            }
        }
    ]

    # exposed service
    services = [
        service.Service {
            name = "clickhouse-operator-metrics"
            labels = {
                "clickhouse.altinity.com/chop" = _app_release_version
                "app" = metadata.__META_APP_NAME
            }
            selector = {
                "app" = metadata.__META_APP_NAME
            }
            ports = [
                corev1.ServicePort {
                    name = "clickhouse-operator-metrics"
                    port = 8888
                }
            ]
        }
    ]
}
