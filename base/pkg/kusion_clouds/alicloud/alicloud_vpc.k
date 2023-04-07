schema AlicloudVPC:	
    cidr_block?: str = "172.16.0.0/12"
    """
    The CIDR block for the VPC. The cidr_block is Optional and default value is 172.16.0.0/12 after v1.119.0+.
    """
    
    description?: str
    """
    The VPC description. Defaults to null.
    """
    
    dry_run?: bool
    """
    Specifies whether to precheck this request only. Valid values: true and false.
    """
    
    enable_ipv6?: bool
    """
    Specifies whether to enable the IPv6 CIDR block. Valid values: false (Default): disables IPv6 CIDR blocks. true: enables IPv6 CIDR blocks. If the enable_ipv6 is true, the system will automatically create a free version of an IPv6 gateway for your private network and assign an IPv6 network segment assigned as /56.
    """
    
    id?: str
    """
    The ID of the VPC.
    """

    ipv6_cidr_block?: str
    """
    The ipv6 cidr block of VPC.
    """
    
    name?: str
    """
    Field name has been deprecated from provider version 1.119.0. New field vpc_name instead.
    """
    
    resource_group_id?: str
    """
    The Id of resource group which the VPC belongs.
    """
    
    route_table_id?: str
    """
    The route table ID of the router created by default on VPC creation.
    """
    
    router_id?: str
    """
    The ID of the router created by default on VPC creation.
    """
    
    router_table_id?: str
    """
    Attribute router_table_id has been deprecated and replaced with route_table_id.
    """
    
    secondary_cidr_blocks?: [str]
    """
    The secondary CIDR blocks for the VPC.
    """
    
    status?: str
    
    tags?: {str:str}
    """
    A mapping of tags to assign to the resource.
    """
    
    user_cidrs?: [str]
    """
    The user cidrs of the VPC.
    """
    
    vpc_name?: str
    """
    The name of the VPC. Defaults to null.
    """