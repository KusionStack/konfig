schema AlicloudDBInstance:

    serverless_config?: [serverlessConfig]

    category?: str   
	
    acl?: str
    
    auto_renew?: bool
    
    auto_renew_period?: int
    
    auto_upgrade_minor_version?: str
    
    ca_type?: str
    
    client_ca_cert?: str
    
    client_ca_enabled?: int
    
    client_cert_revocation_list?: str
    
    client_crl_enabled?: int
    
    connection_string?: str
    
    connection_string_prefix?: str
    
    db_instance_ip_array_attribute?: str
    
    db_instance_ip_array_name?: str
    
    db_instance_storage_type?: str = "cloud_essd"
    
    db_time_zone?: str
    
    encryption_key?: str
    
    engine: str
    
    engine_version: str
    
    force_restart?: bool
    
    fresh_white_list_readins?: str
    
    ha_config?: str
    
    id?: str
    
    instance_charge_type?: str
    
    instance_name?: str
    
    instance_storage: int = 20
    
    instance_type: str
    
    maintain_time?: str
    
    manual_ha_time?: str
    
    modify_mode?: str
    
    monitoring_period?: int
    
    period?: int
    
    port?: str
    
    private_ip_address?: str
    
    released_keep_policy?: str
    
    replication_acl?: str
    
    resource_group_id?: str
    
    security_group_id?: str
    
    security_group_ids?: [str]
    
    security_ip_mode?: str
    
    security_ip_type?: str
    
    security_ips?: [str]
    
    server_cert?: str
    
    server_key?: str
    
    sql_collector_config_value?: int
    
    sql_collector_status?: str
    
    ssl_action?: str
    
    ssl_status?: str
    
    storage_auto_scale?: str
    
    storage_threshold?: int
    
    storage_upper_bound?: int
    
    switch_time?: str
    
    tags?: {str:str}
    
    target_minor_version?: str
    
    tde_status?: str
    
    upgrade_db_instance_kernel_version?: bool
    
    upgrade_time?: str
    
    vswitch_id?: str
    
    whitelist_network_type?: str
    
    zone_id?: str
    
    zone_id_slave_a?: str
    
    zone_id_slave_b?: str
    
    parameters?: [alicloud_db_instance_parameters]
    
schema alicloud_db_instance_parameters:
    name: str
    value: str
    
schema serverlessConfig: 
    max_capacity: float = 8.0
    min_capacity: float = 0.5
    auto_pause: bool = False
    switch_force: bool = False
