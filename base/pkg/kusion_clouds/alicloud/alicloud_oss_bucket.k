schema AlicloudOSSBucket:
    acl?: str
    """
    The canned ACL to apply. Can be "private", "public-read" and "public-read-write". Defaults to "private".
    """
    
    bucket?: str
    """
    The name of the bucket. If omitted, Terraform will assign a random and unique name.
    """
    
    creation_date?: str
    """
    The creation date of the bucket.
    """
    
    extranet_endpoint?: str
    """
    The extranet access endpoint of the bucket.
    """
    
    force_destroy?: bool
    """
    A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. Defaults to "false".
    """
    
    id?: str
    """
    The name of the bucket.
    """
    
    intranet_endpoint?: str
    """
    The intranet access endpoint of the bucket.
    """
    
    location?: str
    """
    The location of the bucket.
    """
    
    logging_isenable?: bool
    """
    The flag of using logging enable container. Defaults true.
    """
    
    owner?: str
    """
    The bucket owner.
    """
    
    policy?: str
    """
    Json format text of bucket policy bucket policy management.
    """
    
    redundancy_type?: str
    """
    The redundancy type to enable. Can be "LRS", and "ZRS". Defaults to "LRS".
    """
    
    storage_class?: str
    """
    The storage class to apply. Can be "Standard", "IA" and "Archive". Defaults to "Standard".
    """
    
    tags?: {str:str}
    """
    A mapping of tags to assign to the bucket. The items are no more than 10 for a bucket.
    """
    
    cors_rule?: [cors_rule]
    """
    A rule of Cross-Origin Resource Sharing. The items of core rule are no more than 10 for every OSS bucket.
    """
    
    lifecycle_rule?: [lifecycle_rule]
    """
     A configuration of object lifecycle management
    """
    
    logging?: [logging]
    """
    A Settings of bucket logging.
    """
    
    referer_config?: [referer_config]
    """
    The configuration of referer.
    """
    
    server_side_encryption_rule?: [server_side_encryption_rule]
    """
    A configuration of server-side encryption
    """
    
    transfer_acceleration?: [transfer_acceleration]
    """
    A transfer acceleration status of a bucket 
    """
    
    versioning?: [versioning]
    """
    A state of versioning
    """
    
    website?: [website]
    """
    A website object(documented below).
    """
    
schema cors_rule:
    allowed_headers?: [str]
    """
    Specifies which headers are allowed.
    """
    
    allowed_methods: [str]
    """
    Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD.
    """
    
    allowed_origins: [str]
    """
    Specifies which origins are allowed.
    """
    
    expose_headers?: [str]
    """
    Specifies expose header in the response.
    """
    
    max_age_seconds?: int
    """
    Specifies time in seconds that browser can cache the response for a preflight request.
    """
    
schema lifecycle_rule:
    enabled: bool
    """
    Specifies lifecycle rule status.
    """
    
    id?: str
    """
    Unique identifier for the rule. If omitted, OSS bucket will assign a unique name.
    """
    
    prefix?: str
    """
    Object key prefix identifying one or more objects to which the rule applies. Default value is null, the rule applies to all objects in a bucket.
    """
    
    abort_multipart_upload?: [abort_multipart_upload]
    """
    Specifies the number of days after initiating a multipart upload when the multipart upload must be completed 
    """
    
    expiration?: [expiration]
    """
    Specifies a period in the object's expire
    """
    
    noncurrent_version_expiration?: [noncurrent_version_expiration]
    """
    Specifies when noncurrent object versions expire
    """
    
    noncurrent_version_transition?: [noncurrent_version_transition]
    """
    Specifies when noncurrent object versions transitions
    """
    
    transitions?: [transitions]
    """
    Specifies the time when an object is converted to the IA or archive storage class during a valid life cycle.
    """

schema abort_multipart_upload:
    created_before_date?: str
    """
    Specifies the time before which the rules take effect. The date must conform to the ISO8601 format and always be UTC 00:00. For example: 2002-10-11T00:00:00.000Z indicates that parts created before 2002-10-11T00:00:00.000Z are deleted, and parts created after this time (including this time) are not deleted.
    """
    
    days?: int
    """
    Specifies the number of days after object creation when the specific rule action takes effect.
    """

schema expiration:
    created_before_date?: str
    """
    Specifies the time before which the rules take effect. The date must conform to the ISO8601 format and always be UTC 00:00. For example: 2002-10-11T00:00:00.000Z indicates that objects updated before 2002-10-11T00:00:00.000Z are deleted or converted to another storage class, and objects updated after this time (including this time) are not deleted or converted.
    """
    
    date?: str
    """
    Specifies the date after which you want the corresponding action to take effect. The value obeys ISO8601 format like 2017-03-09.
    """
    
    days?: int
    """
    Specifies the number of days after object creation when the specific rule action takes effect.
    """
    
    expired_object_delete_marker?: bool
    """
    On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct OSS to delete expired object delete markers. This cannot be specified with Days, Date or CreatedBeforeDate in a Lifecycle Expiration Policy.
    """

schema noncurrent_version_expiration:
    days: int
    """
    Specifies the number of days noncurrent object versions expire.
    """
    
schema noncurrent_version_transition:
    days: int
    """
    Specifies the number of days noncurrent object versions transition.
    """
    
    storage_class: str
    """
    Specifies the storage class that objects that conform to the rule are converted into. The storage class of the objects in a bucket of the IA storage class can be converted into Archive but cannot be converted into Standard. Values: IA, Archive.
    """
    	
schema transitions:
    created_before_date?: str
    """
    Specifies the time before which the rules take effect. The date must conform to the ISO8601 format and always be UTC 00:00. For example: 2002-10-11T00:00:00.000Z indicates that objects updated before 2002-10-11T00:00:00.000Z are deleted or converted to another storage class, and objects updated after this time (including this time) are not deleted or converted.
    """
    
    days?: int
    """
    Specifies the number of days after object creation when the specific rule action takes effect.
    """
    
    storage_class?: str
    """
    Specifies the storage class that objects that conform to the rule are converted into. The storage class of the objects in a bucket of the IA storage class can be converted into Archive but cannot be converted into Standard. Values: IA, Archive.
    """

schema logging:
    target_bucket: str
    """
     The name of the bucket that will receive the log objects.
    """
    
    target_prefix?: str
    """
    To specify a key prefix for log objects.
    """

schema referer_config:
    allow_empty?: bool
    """
    Allows referer to be empty. Defaults false.
    """
    
    referers: [str]
    """
    The list of referer.
    """

schema server_side_encryption_rule:
    kms_master_key_id?: str
    """
    The alibaba cloud KMS master key ID used for the SSE-KMS encryption.
    """
    
    sse_algorithm: str
    """
    The server-side encryption algorithm to use. Possible values: AES256 and KMS.
    """

schema transfer_acceleration:
    enabled: bool
    """
     Specifies the accelerate status of a bucket.
    """

schema versioning:
    status: str
    """
    Specifies the versioning state of a bucket. Valid values: Enabled and Suspended.
    """

schema website:
    error_document?: str
    """
    Alicloud OSS returns this index document when requests are made to the root domain or any of the subfolders.
    """
    
    index_document: str
    """
    An absolute path to the document to return in case of a 4XX error.
    """
    