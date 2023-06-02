import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.rbac
import base.pkg.kusion_models.kube.backend
import base.pkg.kusion_models.kube.resource
import base.pkg.kusion_models.kube.metadata
import base.pkg.kusion_kubernetes.apimachinery.apis
import base.pkg.kusion_kubernetes.api.core.v1 as corev1
import base.pkg.kusion_prometheus.monitoring.v1 as monitoringv1
import base.pkg.kusion_prometheus.monitoring.v1alpha1 as monitoringv1alpha1
import base.pkg.kusion_kubevela.v1beta1 as kubevelav1beta1
import base.pkg.kusion_models.commons
import base.pkg.kusion_vault.v1 as vaultv1

import manifests

# predefined functions
# lambda: check if two k8s resources are identical
checkIdentical = lambda a, b {
    _a_namespace = a.metadata.namespace or "default"
    _b_namespace = b.metadata.namespace or "default"

    identical = a.apiVersion == b.apiVersion \
    and a.kind == b.kind \
    and a.metadata.name == b.metadata.name \
    and _a_namespace == _b_namespace
}
# Output the resource
manifestsResourceMap = lambda resource_map: {str: []} {
    # Convert resource map into a resource list
    _resource_list = [res_list for _, res_list in resource_map]
    # Use `sum` function to flatten the resource list
    _resource_list = sum(_resource_list, [])
    manifests.yaml_stream(_resource_list)
}

# lambda: remove duplicated resource
remove_duplicated_iter = lambda data: [], func {
    [data[i] for i in range(len(data)) if sum([1 for jdata in data[i+1:] if func(data[i], jdata)]) == 0]
}

__renderServerFrontendInstances__ = [inst for inst in frontend.Server.instances() if typeof(inst) == "Server"]
__renderServerBackendInstances__ = [backend.ServerBackend(inst) for inst in __renderServerFrontendInstances__]

__renderJobFrontendInstances__ = [inst for inst in frontend.Job.instances() if typeof(inst) == "Job"]
__renderJobBackendInstances__ = [backend.JobBackend(inst) for inst in __renderJobFrontendInstances__]
__renderFrontendInstances__ = [
    *__renderServerFrontendInstances__
    *__renderJobFrontendInstances__
]
__renderBackendInstances__ = [
    *__renderServerBackendInstances__
    *__renderJobBackendInstances__
]

# rbac map, kind to resource array
__rbac_map__: resource.ResourceMapping = {
    if len(rbac.ClusterRoleBinding.instances()) > 0:
        ClusterRoleBinding += [r.kubernetes for r in rbac.ClusterRoleBinding.instances()]
    if len(rbac.ClusterRole.instances()) > 0: 
        ClusterRole += [r.kubernetes for r in rbac.ClusterRole.instances()]
    if len(rbac.RoleBinding.instances()) > 0: 
        RoleBinding += [r.kubernetes for r in rbac.RoleBinding.instances()]
    if len(rbac.Role.instances()) > 0: 
        Role += [r.kubernetes for r in rbac.Role.instances()]
}

# prometheus
__prometheus_map__: resource.ResourceMapping = {
    PrometheusRule += monitoringv1.PrometheusRule.instances()
    AlertmanagerConfig += monitoringv1alpha1.AlertmanagerConfig.instances()
    Probe += monitoringv1.Probe.instances()
    Prometheus += monitoringv1.Prometheus.instances()
    Alertmanager += monitoringv1.Alertmanager.instances()
}
# vault
__vault_map__: resource.ResourceMapping = {
    SecretProviderClass += vaultv1.SecretProviderClass.instances()
}

# k8s
__k8s__: resource.ResourceMapping = {
    Service += corev1.Service.instances()
    ServiceAccount += corev1.ServiceAccount.instances()
}

# merge resource map
__array_of_resource_map___: [resource.ResourceMapping] = [
    _inst?.kubernetes for _inst in __renderBackendInstances__ if _inst?.kubernetes
] | [__rbac_map__] | [__prometheus_map__] | [__vault_map__] | [__k8s__]

__resource_map_original___: {str: []} = {
    _kind += [r for key, r in _res] \
        for _index, _resource_map in __array_of_resource_map___  \
            for _kind, _res in _resource_map if _kind not in ["__settings__"]
}

# Terraform provider resources
_providerResource: [commons.ResourceBuilder] = sum([_inst.provider for _inst in __renderServerBackendInstances__ if _inst?.provider], [])
_providerResourceMapping = {"${p.result.id}" = [p.result] for p in _providerResource}

# remove duplicates
__resource_map___: {str: []} = {kind = remove_duplicated_iter(res_list, checkIdentical) for kind, res_list in __resource_map_original___}

# decide which kind of render we should use
# we will choose KubeVela Application once the type of 'KubeVelaApplication' appears
__is_kubevela_application__: bool = "KubeVelaApplication" in [inst.renderType for inst in __renderServerFrontendInstances__]

# kubernetes id: apiVersion:Kind:Namespace:Name
getId = lambda _resource {
    _resource.apiVersion + ":" + _resource.kind + ":" + (_resource.metadata.namespace + ":" if _resource.metadata.namespace else "") + _resource.metadata.name 
}

if option("__konfig_output_format__")?.lower() == "raw":
    manifestsResourceMap(_providerResourceMapping | { 
        _kind: [_resource for _resource in _res] \
            for _kind, _res in __resource_map___
    })
else:
    if __is_kubevela_application__:
        # generate KubeVela Application with K8s resource map
        kubevela_app: kubevelav1beta1.Application {
            metadata = apis.ObjectMeta {
                name = metadata.__META_APP_NAME
                namespace = metadata.__META_ENV_TYPE_NAME
            }

            spec = kubevelav1beta1.CoreOamDevV1beta1ApplicationSpec {
                components = [
                    kubevelav1beta1.CoreOamDevV1beta1ApplicationSpecComponentsItems0 {
                        name = metadata.__META_APP_NAME + "-" + (_kind).lower()
                        type = "k8s-objects" 
                        properties = {
                            "objects" = [_resource for _resource in _res if _resource]
                        }
                    } \
                    for i, v in resource.kubernetesOrders \
                        for _kind, _res in __resource_map___ if _kind == v and _res
                ] 
                policies = [
                    kubevelav1beta1.CoreOamDevV1beta1ApplicationSpecPoliciesItems0 {
                        name = "default"
                        type = "apply-once"
                        properties = {
                            clusters = [
                                metadata.__META_CLUSTER_NAME
                            ]
                            namespace = metadata.__META_ENV_TYPE_NAME
                        }
                    }
                ]
            }
        }

        # structure output for kubevela application
        kubevela_output = {
            "${kubevela_app.kind}": [{
                "id" = getId(kubevela_app)
                "type" = "Kubernetes"
                "attributes" = kubevela_app
            }]
        }
        manifestsResourceMap(_providerResourceMapping | kubevela_output)
    else:
        server_output = {
            _kind: [
                {
                    "id" = getId(_resource)
                    "type" = "Kubernetes"
                    "dependsOn" = [
                        getId(dependOn) \
                            for i, v in resource.kubernetesOrders if v == _kind \
                                for k in resource.kubernetesOrders[:i] if k in __resource_map___ \
                                    for dependOn in __resource_map___[k]
                    ]
                    "attributes" = _resource
                } for _resource in _res
            ] for _kind, _res in __resource_map___ 
        }
        manifestsResourceMap(_providerResourceMapping | server_output)
