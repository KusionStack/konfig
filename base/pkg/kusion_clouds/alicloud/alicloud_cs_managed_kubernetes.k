schema AlicloudManagedKubernetes:
    api_audiences?: [str]
    
    availability_zone?: str
    
    certificate_authority?: {str:str}
    
    client_cert?: str
    
    client_key?: str
    
    cluster_ca_cert?: str
    
    cluster_domain?: str
    
    cluster_network_type?: str
    
    cluster_spec?: str
    
    connections?: {str:str}
    
    control_plane_log_components?: [str]
    
    control_plane_log_project?: str
    
    control_plane_log_ttl?: str
    
    cpu_policy?: str
    
    custom_san?: str
    
    deletion_protection?: bool
    
    enable_ssh?: bool
    
    encryption_provider_key?: str
    
    exclude_autoscaler_nodes?: bool
    
    force_update?: bool
    
    id?: str
    
    image_id?: str
    
    install_cloud_monitor?: bool
    
    is_enterprise_security_group?: bool
    
    key_name?: str
    
    kms_encrypted_password?: str
    
    kms_encryption_context?: {str:str}
    
    kube_config?: str
    
    load_balancer_spec?: str
    
    name?: str
    
    name_prefix?: str
    
    nat_gateway_id?: str
    
    new_nat_gateway?: bool
    
    node_cidr_mask?: int
    
    node_name_mode?: str
    
    node_port_range?: str
    
    os_type?: str
    
    password?: str
    
    platform?: str
    
    pod_cidr?: str
    
    pod_vswitch_ids?: [str]
    
    proxy_mode?: str
    
    rds_instances?: [str]
    
    resource_group_id?: str
    
    retain_resources?: [str]
    
    runtime?: {str:str}
    
    security_group_id?: str
    
    service_account_issuer?: str
    
    service_cidr?: str
    
    slb_id?: str
    
    slb_internet?: str
    
    slb_internet_enabled?: bool
    
    slb_intranet?: str
    
    tags?: {str:str}
    
    timezone?: str
    
    user_ca?: str
    
    user_data?: str
    
    version?: str
    
    vpc_id?: str
    
    vswitch_ids?: [str]
    
    worker_auto_renew?: bool
    
    worker_auto_renew_period?: int
    
    worker_data_disk_category?: str
    
    worker_data_disk_size?: int
    
    worker_disk_category?: str
    
    worker_disk_performance_level?: str
    
    worker_disk_size?: int
    
    worker_disk_snapshot_policy_id?: str
    
    worker_instance_charge_type?: str
    
    worker_instance_type?: str
    
    worker_instance_types?: [str]
    
    worker_nodes?: [worker_nodes]
    
    worker_number?: int
    
    worker_numbers?: [int]
    
    worker_period?: int
    
    worker_period_unit?: str
    
    worker_ram_role_name?: str
    
    worker_vswitch_ids: [str]
    
    addons?: [addons]
    
    log_config?: [log_config]
    
    maintenance_window?: [maintenance_window]
    
    taints?: [taints]
    
    worker_data_disks?: [worker_data_disks]
    
schema addons:
    config?: str
    
    disabled?: bool
    
    name?: str
    
schema log_config:
    project?: str
    
    type: str
    
schema maintenance_window:
    duration: str
    
    enable: bool
    
    maintenance_time: str
    
    weekly_period: str
    
schema taints:
    effect?: str
    
    key?: str
    
    value?: str
    
schema worker_data_disks:
    auto_snapshot_policy_id?: str
    
    category?: str
    
    device?: str
    
    encrypted?: str
    
    kms_key_id?: str
    
    name?: str
    
    performance_level?: str
    
    size?: str
    
    snapshot_id?: str
    
schema worker_nodes:
    id: str
    
    name: str
    
    private_ip: str
    