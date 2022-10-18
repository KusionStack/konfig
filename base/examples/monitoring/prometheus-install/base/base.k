import base.pkg.kusion_models.kube.frontend.rbac
import base.pkg.kusion_kubernetes.api.core.v1 as corev1


_rbac_name = "prometheus"
_common_namespace = "default"

# 1. create a service account 
_prometheus_sa: corev1.ServiceAccount {
    metadata = {
        name = _rbac_name
        namespace = _common_namespace
    }
}

# 2. prepare required permissions with api groups and resources
_prometheus_clusterrole: rbac.ClusterRole {
    metadata = {
        name = _rbac_name
        namespace = _common_namespace
    }
    rules = [
        {
            apiGroups = [""]
            resources = ["nodes", "nodes/metrics", "services", "endpoints", "pods"]
            verbs = ["get", "list", "watch"]
        }
        {
            apiGroups = [""]
            resources = ["configmaps"]
            verbs = ["get"]
        }
        {
            apiGroups = ["networking.k8s.io"]
            resources = ["ingresses"]
            verbs = ["get", "list", "watch"]
        }
        {
            nonResourceURLs = ["/metrics"]
            verbs = ["get"]
        }
    ]
}

# 3. bind service account and cluster role
rbac.ClusterRoleBinding{
    metadata = {
        name = _rbac_name
        namespace = _common_namespace
    }
    roleRef = {
        apiGroup = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = _prometheus_clusterrole.metadata.name
    }
    subjects = [
        {
            kind = "ServiceAccount"
            name = _prometheus_sa.metadata.name
            namespace = _prometheus_sa.metadata.namespace
        }
    ]
}