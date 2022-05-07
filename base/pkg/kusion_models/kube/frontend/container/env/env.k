import regex

schema Env:
    """ Env represents an environment variable present in a Container.

    Attributes
    ----------
    name: str, default is Undefined, required.
        A Container-level attribute.
        The env name. This must be a C_IDENTIFIER.
    value: str, default is Undefined, optional.
        A Container-level attribute.
        The simple literal value.
    valueFrom: EnvValueFrom, default is Undefined, optional.
        A Container-level attribute.
        The ref source of this env.
    """

    name: str
    value?: str
    valueFrom?: EnvValueFrom

    check:
        len(name) <= 63, "a valid env name must be no more than 63 characters"
        regex.match(name, r"[A-Za-z_][A-Za-z0-9_]*"), "a valid env name must start with alphabetic character or '_', followed by a string of alphanumeric characters or '_'"
        not valueFrom if value, "valueFrom may not be specified when `value` is not empty"

schema EnvValueFrom:
    """ EnvValueFrom represents the source of the value of an Env.

    Attributes
    ----------
    fieldRef: ObjectFieldSelector, default is Undefined, optional.
        A Container-level attribute.
        Selects a key of a field.
    configMapKeyRef: ObjectKeySelector, default is Undefined, optional.
        A Container-level attribute.
        Selects a key of a ConfigMap.
    secretKeyRef: ObjectKeySelector, default is Undefined, optional.
        A Container-level attribute.
        Selects a key of a secret.
    """

    fieldRef?: ObjectFieldSelector
    configMapKeyRef?: ObjectKeySelector
    secretKeyRef?: ObjectKeySelector

    check:
        notfieldRef or notconfigMapKeyRef or notsecretKeyRef, "may not have more than one field specified at a time"
        fieldRef or configMapKeyRef or secretKeyRef, "must specify one of: `fieldRef`, `configMapKeyRef` or `secretKeyRef`"

schema ObjectKeySelector:
    """ ObjectKeySelector contains enough information to let you locate the referenced object.

    Attributes
    ----------
    name: str, default is Undefined, required.
        A Container-level attribute.
        The name of object, typically a ConfigMap or Secret name.
    key: str, default is Undefined, required.
        A Container-level attribute.
        The key of the object to select from.
    """

    name: str
    key: str

schema ObjectFieldSelector:
    """ ObjectFieldSelector contains enough information to let you select field of an object.

    Attributes
    ----------
    apiVersion: str, default is Undefined, required.
        A Container-level attribute.
        Version of the schema the FieldPath is written in terms of.
    fieldPath: str, default is Undefined, required.
        A Container-level attribute.
        Path of the field to select of an object.
    """

    apiVersion: str
    fieldPath: str

schema EnvFromSource:
    """ EnvFromSource represents the source of a set of ConfigMaps or Secrets.

    Attributes
    ----------
    configMapRef: str, default is Undefined, optional.
        A Container-level attribute.
        The ConfigMap name to select from.
    secretRef: str, default is Undefined, optional.
        A Container-level attribute.
        The Secret name to select from.
    """

    configMapRef?: str
    secretRef?: str

    check:
        not configMapRef or not secretRef, "can not set configMapRef and secretRef in env at the same time"
        configMapRef or secretRef, "must specify one of: `configMapRef` or `secretRef`"
