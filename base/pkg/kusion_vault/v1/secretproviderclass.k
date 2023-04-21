import base.pkg.kusion_kubernetes.apimachinery.apis

schema SecretProviderClass:
    """ SecretProviderClass is the Schema for the secretproviderclasses API
        
    Attributes
    ----------
    apiVersion: "secrets-store.csi.x-k8s.io/v1", default is "secrets-store.csi.x-k8s.io/v1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind: "SecretProviderClass", default is "SecretProviderClass", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata: apis.ObjectMeta, default is Undefined, optional
        Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
    spec: SecretProviderClassSpec, default is Undefined, optional
        Spec defines the desired state of SecretProviderClass
    """
    apiVersion: "secrets-store.csi.x-k8s.io/v1" = "secrets-store.csi.x-k8s.io/v1"
    kind: "SecretProviderClass" = "SecretProviderClass"
    metadata?: apis.ObjectMeta
    spec?: SecretProviderClassSpec

schema SecretProviderClassSpec:
    """ SecretProviderClassSpec defines the desired state of SecretProviderClass

    Attributes
    ----------
    provider: str, default is Undefined, Optional
        Provider is configuration for provider name
    parameters: {str:str}, default is Undefined, Optional
        Parameters is configuration for specific provider
    secretObjects: [SecretObject], default is Undefined, Optional
        SecretObjects are the desired state of synced K8s secret objects 
    """
    provider?: str
    parameters?: {str:str}
    secretObjects?: [SecretObject]

schema SecretObject:
    """ SecretObject defines the desired state of synced K8s secret objects

    Attributes
    ----------
    secretName: str, default is Undefined, Optional
        SecretName is name of the K8s secret object
    type: str, default is Undefined, Optional
        Type is K8s secret object
    labels: {str:str}, default is Undefined, Optional
        Labels are labels of K8s secret object
    annotations: {str:str}, default is Undefined, Optional
        Annotations are annotations of k8s secret object
    data: [SecretObjectData], default is Undefined, Optional
        data defines the desired state of synced K8s secret object data
    """
    secretName?: str
    type?: str
    labels?: {str:str}
    annotations?: {str:str}
    data?: [SecretObjectData]

schema SecretObjectData:
    """ SecretObjectData defines the desired state of synced K8s secret object data
    
    Attributes
    ----------
    objectName: str, default is Undefined, Optional
        SecretName is name of the object to sync
    key: str, default is Undefined, Optional
        Type is data field to populate
    """
    objectName?: str
    key?: str