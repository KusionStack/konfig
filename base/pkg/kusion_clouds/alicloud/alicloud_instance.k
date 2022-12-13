schema AlicloudInstance: 
    allocate_public_ip?: bool
    """
    It has been deprecated from version "1.7.0". Setting "internet_max_bandwidth_out" larger than 0 can allocate a public ip address for an instance.
    """
    
    auto_release_time?: str
    """
    The automatic release time of the PostPaid instance. The time follows the ISO 8601 standard and is in UTC time. Format: yyyy-MM-ddTHH:mm:ssZ. It must be at least half an hour later than the current time and less than 3 years since the current time. Set it to null can cancel automatic release attribute and the ECS instance will not be released automatically.
    """
    
    auto_renew_period?: int
    """
    Auto renewal period of an instance, in the unit of month. It is valid when instance_charge_type is PrePaid. Default to 1. Valid value:

    [1, 2, 3, 6, 12] when period_unit in "Month"
    [1, 2, 3] when period_unit in "Week"
    """
    
    availability_zone?: str
    """
    The Zone to start the instance in. It is ignored and will be computed when set vswitch_id
    """
    
    credit_specification?: str
    """
    Performance mode of the t5 burstable instance. Valid values: 'Standard', 'Unlimited'.
    """
    
    deletion_protection?: bool
    """
    Whether enable the deletion protection or not. Default value: false.

    true: Enable deletion protection.
    false: Disable deletion protection.
    """
    
    deployment_set_group_no?: str
    
    deployment_set_id?: str
    """
    The ID of the deployment set to which to deploy the instance.
    """
    
    description?: str
    """
    Description of the instance, This description can have a string of 2 to 256 characters, It cannot begin with http:// or https://. Default value is null.
    """
    
    dry_run?: bool
    """
    Specifies whether to send a dry-run request. Default to false.

    true: Only a dry-run request is sent and no instance is created. The system checks whether the required parameters are set, and validates the request format, service permissions, and available ECS instances. If the validation fails, the corresponding error code is returned. If the validation succeeds, the DryRunOperation error code is returned.
    false: A request is sent. If the validation succeeds, the instance is created.
    """
    
    force_delete?: bool
    """
    If it is true, the "PrePaid" instance will be change to "PostPaid" and then deleted forcibly. However, because of changing instance charge type has CPU core count quota limitation, so strongly recommand that "Donnot modify instance charge type frequentlly in one month".
    """
    
    host_name?: str
    """
    Host name of the ECS, which is a string of at least two characters.
    """
    
    hpc_cluster_id?: str
    """
    The ID of the Elastic High Performance Computing (E-HPC) cluster to which to assign the instance.
    """
    
    id?: str
    
    image_id: str
    """
    The Image to use for the instance. ECS instance's image can be replaced via changing image_id. When it is changed, the instance will reboot to make the change take effect.
    """
    
    include_data_disks?: bool
    """
    Whether to change instance disks charge type when changing instance charge type.
    """
    
    instance_charge_type?: str
    """
    Valid values are PrePaid, PostPaid, The default is PostPaid.
    """
    
    instance_name?: str
    """
    The name of the ECS. This instance_name can have a string of 2 to 128 characters, must contain only alphanumeric characters or hyphens, such as "-",".","_", and must not begin with a hyphen, and must not begin with http:// or https://. If not specified, Terraform will autogenerate a default name is ECS-Instance
    """
    
    instance_type: str
    """
    The type of instance to start. When it is changed, the instance will reboot to make the change take effect.
    """
    
    internet_charge_type?: str
    """
    Internet charge type of the instance, Valid values are PayByBandwidth, PayByTraffic. Default is PayByTraffic. At present, 'PrePaid' instance cannot change the value to "PayByBandwidth" from "PayByTraffic".
    """
    
    internet_max_bandwidth_in?: int
    """
    Maximum incoming bandwidth from the public network, measured in Mbps (Mega bit per second). Value range: [1, 200]. If this value is not specified, then automatically sets it to 200 Mbps.
    """
    
    internet_max_bandwidth_out?: int
    """
    Maximum outgoing bandwidth to the public network, measured in Mbps (Mega bit per second). Value range: [0, 100]. Default to 0 Mbps.
    """
    
    io_optimized?: str
    """
    It has been deprecated on instance resource. All the launched alicloud instances will be I/O optimized.
    """
    
    is_outdated?: bool
    """
    Whether to use outdated instance type. Default to false.
    """
    
    key_name?: str
    """
    The name of key pair that can login ECS instance successfully without password. If it is specified, the password would be invalid.
    """
    
    kms_encrypted_password?: str
    """
    An KMS encrypts password used to an instance. If the password is filled in, this field will be ignored. When it is changed, the instance will reboot to make the change take effect.
    """
    
    kms_encryption_context?: {str:str}
    """
    An KMS encryption context used to decrypt kms_encrypted_password before creating or updating an instance with kms_encrypted_password. See Encryption Context. It is valid when kms_encrypted_password is set. When it is changed, the instance will reboot to make the change take effect.
    """
    
    password?: str
    """
    Password to an instance is a string of 8 to 30 characters. It must contain uppercase/lowercase letters and numerals, but cannot contain special symbols. When it is changed, the instance will reboot to make the change take effect.
    """
    
    period?: int
    """
    The duration that you will buy the resource, in month. It is valid when instance_charge_type is PrePaid. Valid values:
    [1-9, 12, 24, 36, 48, 60] when period_unit in "Month"
    [1-3] when period_unit in "Week" -> NOTE: The attribute period is only used to create Subscription instance or modify the PayAsYouGo instance to Subscription. Once effect, it will not be modified that means running terraform apply will not effect the resource.
    """
    
    period_unit?: str
    """
    The duration unit that you will buy the resource. It is valid when instance_charge_type is 'PrePaid'. Valid value: ["Week", "Month"]. Default to "Month".
    """
    
    private_ip?: str
    """
    Instance private IP address can be specified when you creating new instance. It is valid when vswitch_id is specified. When it is changed, the instance will reboot to make the change take effect.
    """
    
    public_ip?: str
    
    renewal_status?: str
    """
    Whether to renew an ECS instance automatically or not. It is valid when instance_charge_type is PrePaid. Default to "Normal". Valid values:

    AutoRenewal: Enable auto renewal.
    Normal: Disable auto renewal.
    NotRenewal: No renewal any longer. After you specify this value, Alibaba Cloud stop sending notification of instance expiry, and only gives a brief reminder on the third day before the instance expiry.
    """
    
    resource_group_id?: str
    """
    The Id of resource group which the instance belongs.
    """
    
    role_name?: str
    """
    Instance RAM role name. The name is provided and maintained by RAM. You can use alicloud_ram_role to create a new one.
    """
    
    secondary_private_ip_address_count?: int
    """
    The number of private IP addresses to be automatically assigned from within the CIDR block of the vswitch. NOTE: To assign secondary private IP addresses, you must specify secondary_private_ips or secondary_private_ip_address_count but not both.
    """
    
    secondary_private_ips?: [str]
    """
    A list of Secondary private IP addresses which is selected from within the CIDR block of the VSwitch.
    """
    
    security_enhancement_strategy?: str
    """
    The security enhancement strategy.

    Active: Enable security enhancement strategy, it only works on system images.
    Deactive: Disable security enhancement strategy, it works on all images.
    """
    
    security_groups: [str]
    """
    A list of security group ids to associate with.
    """

    spot_price_limit?: int
    """
    The hourly price threshold of a instance, and it takes effect only when parameter 'spot_strategy' is 'SpotWithPriceLimit'. Three decimals is allowed at most.
    """
    
    spot_strategy?: str
    """
    The spot strategy of a Pay-As-You-Go instance, and it takes effect only when parameter instance_charge_type is 'PostPaid'. Value range:

    NoSpot: A regular Pay-As-You-Go instance.
    SpotWithPriceLimit: A price threshold for a spot instance
    SpotAsPriceGo: A price that is based on the highest Pay-As-You-Go instance
    Default to NoSpot. Note: Currently, the spot instance only supports domestic site account.
    """
    
    status?: str
    """
    The instance status. Valid values: ["Running", "Stopped"]. You can control the instance start and stop through this parameter. Default to Running.
    """
    
    subnet_id?: str
    
    system_disk_auto_snapshot_policy_id?: str
    """
    The ID of the automatic snapshot policy applied to the system disk.
    """
    
    system_disk_category?: str
    """
    Valid values are ephemeral_ssd, cloud_efficiency, cloud_ssd, cloud_essd, cloud. cloud only is used to some none I/O optimized instance. Default to cloud_efficiency.
    """
    
    system_disk_description?: str
    """
    The description of the system disk. The description must be 2 to 256 characters in length and cannot start with http:// or https://.
    """
    
    system_disk_name?: str
    """
    The name of the system disk. The name must be 2 to 128 characters in length and can contain letters, digits, periods (.), colons (:), underscores (_), and hyphens (-). It must start with a letter and cannot start with http:// or https://.
    """
    
    system_disk_performance_level?: str
    """
    The performance level of the ESSD used as the system disk, Valid values: PL0, PL1, PL2, PL3, Default to PL1
    """
    
    system_disk_size?: int
    """
    Size of the system disk, measured in GiB. Value range: [20, 500]. The specified value must be equal to or greater than max{20, Imagesize}. Default value: max{40, ImageSize}.
    """
    
    tags?: {str:str}
    """
    A mapping of tags to assign to the resource.

    Key: It can be up to 64 characters in length. It cannot begin with "aliyun", "acs:", "http://", or "https://". It cannot be a null string.
    Value: It can be up to 128 characters in length. It cannot begin with "aliyun", "acs:", "http://", or "https://". It can be a null string.  
    """
    
    user_data?: str
    """
    User-defined data to customize the startup behaviors of an ECS instance and to pass data into an ECS instance. From version 1.60.0, it can be update in-place. If updated, the instance will reboot to make the change take effect.
    """
    
    volume_tags?: {str:str}
    """
    A mapping of tags to assign to the devices created by the instance at launch time.

    Key: It can be up to 64 characters in length. It cannot begin with "aliyun", "acs:", "http://", or "https://". It cannot be a null string.
    Value: It can be up to 128 characters in length. It cannot begin with "aliyun", "acs:", "http://", or "https://". It can be a null string.
    """
    
    vswitch_id?: str
    """
    The virtual switch ID to launch in VPC. This parameter must be set unless you can create classic network instances. When it is changed, the instance will reboot to make the change take effect.
    """
    
    data_disks?: [data_disks]
    """
    The list of data disks created with instance.
    """
    
schema data_disks:
    auto_snapshot_policy_id?: str
    """
    The ID of the automatic snapshot policy applied to the system disk.
    """
    
    category?: str
    """
    The category of the disk
    """
    
    delete_with_instance?: bool
    """
    Delete this data disk when the instance is destroyed. It only works on cloud, cloud_efficiency, cloud_essd, cloud_ssd disk. If the category of this data disk was ephemeral_ssd, please don't set this param. Default value: true.
    """
    
    description?: str
    """
    The description of the data disk.
    """
    
    encrypted?: bool
    """
    Encrypted the data in this disk. Default value: false.
    """
    
    kms_key_id?: str
    """
    The KMS key ID corresponding to the Nth data disk.
    """
    
    name?: str
    """
    The name of the data disk.
    """
    
    performance_level?: str
    """
    The performance level of the ESSD used as data disk
    """
    
    size: int
    """
    The size of the data disk
    """
    
    snapshot_id?: str
    """
    The snapshot ID used to initialize the data disk. If the size specified by snapshot is greater that the size of the disk, use the size specified by snapshot as the size of the data disk.
    """
    