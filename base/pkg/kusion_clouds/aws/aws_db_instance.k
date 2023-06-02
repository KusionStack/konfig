schema AWSDBInstance: 
    address?: str
    
    allocated_storage?: int

    apply_immediately?: bool = false

    arn?: str

    auto_minor_version_upgrade?: bool = true

    availability_zone?: str

    backup_window?: str

    ca_cert_identifier?: str

    copy_tags_to_snapshot?: bool = false

    customer_owned_ip_enabled?: bool = false

    db_name?: str

    db_subnet_group_name?: str = "default"

    delete_automated_backups?: bool = true

    deletion_protection?: bool = false

    domain?: str

    domain_iam_role_name?: str

    endpoint?: str

    engine: str

    engine_version: str

    engine_version_actual?: str

    hosted_zone_id?: str

    iam_database_authentication_enabled?: bool = false

    id?: str

    identifier?: str

    identifier_prefix?: str

    instance_class?: str

    iops?: int

    kms_key_id?: str

    latest_restorable_time?: str

    license_model?: str

    max_allocated_storage?: int

    monitoring_interval?: int

    monitoring_role_arn?: str

    multi_az?: bool = false

    nchar_character_set_name?: str

    network_type?: str

    option_group_name?: str

    parameter_group_name?: str

    password?: str

    performance_insights_enabled?: bool = false

    performance_insights_kms_key_id?: str

    performance_insights_retention_period?: int

    port?: int

    publicly_accessible?: bool

    replica_mode?: str

    replicate_source_db?: str

    resource_id?: str

    skip_final_snapshot?: bool = true

    status?: str

    storage_encrypted?: bool

    storage_throughput?: int

    storage_type?: str

    username?: str

    vpc_security_group_ids?: [str]
