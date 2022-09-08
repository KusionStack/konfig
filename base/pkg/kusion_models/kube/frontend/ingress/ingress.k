import base.pkg.kusion_models.kube.frontend.common
import base.pkg.kusion_kubernetes.api.networking.v1 as networking_v1

schema Ingress(common.Metadata):
    """Ingress is a collection of rules that allow inbound connections to reach the endpoints defined by a backend. 
    An Ingress can be configured to give services externally-reachable urls, load balance traffic, terminate SSL, offer name based virtual hosting etc.

    Attributes
    ----------
    name: str
        The name of the resource.
        Name must be unique within a namespace. It's required when creating
        resources, although some resources may allow a client to request the
        generation of an appropriate name automatically.
        Name is primarily intended for creation idempotence and configuration
        definition. Cannot be updated. More info:
        http://kubernetes.io/docs/user-guide/identifiers#names
        Required.
    labels: {str:str}
        Labels is a map of string keys and values that can be used to
        organize and categorize (scope and select) objects.
        May match selectors of replication controllers and services.
        More info: http://kubernetes.io/docs/user-guide/labels
        Optional.
    annotations: {str:str}
        Annotations is an unstructured key value map stored with a
        resource that may be set by external tools to store and retrieve
        arbitrary metadata. They are not queryable and should be preserved
        when modifying objects.
        More info: http://kubernetes.io/docs/user-guide/annotations
        Optional.
    namespace: str
        Namespaces are intended for use in environments with many users spread
        across multiple teams, or projects.
        For clusters with a few to tens of users, you should not need to create
        or think about namespaces at all. Start using namespaces when you need the features they provide.
        More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
        Optional.
    rules: [networking_v1beta1.IngressRule]
        A list of host rules used to configure the Ingress. If unspecified, or no rule matches, all traffic is sent to the default backend.
    tls : [IngressTLS], default is Undefined, optional
        TLS configuration. Currently the Ingress only supports a single TLS port, 443. If multiple members of this list specify different hosts, they will be multiplexed on the same port according to the hostname specified through the SNI TLS extension, if the ingress controller fulfilling the ingress supports SNI.

    Examples
    --------
    ingress.Ingress {
        name = "example-ingress"
        rules = [
            {
                host = "your-domain.com"
                http.paths = [
                    {
                        path = "/apple"
                        pathType = "Prefix"
                        backend.service: {
                            name = "app-service"
                            port.number = 5678
                        }
                    }
                ]
            }
        ]
        tls = [
            {
              hosts = ["your-domain.com"]
              secretName = "example-ingress-tls"
            }
        ]
    }
    """
    rules?: [networking_v1.IngressRule]
    tls?: [networking_v1.IngressTLS]
