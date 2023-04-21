schema AlicloudVswitch:	
    availability_zone?: str
    """
    Field availability_zone has been deprecated from provider version 1.119.0. New field zone_id instead.
    """
    
    cidr_block: str = "172.16.0.0/24"
    """
    The CIDR block for the switch. The default value is 172.16.0.0/24.
    """
    
    description?: str
    """
    The switch description. Defaults to null.
    """
    
    id?: str
    """
    The ID of the switch.
    """
    
    name?: str
    """
    Field name has been deprecated from provider version 1.119.0. New field vswitch_name instead.
    """
    
    status?: str
    """
    The status of the switch.
    """
    
    tags?: {str:str}
    """
    A mapping of tags to assign to the resource.
    """
    
    vpc_id: str
    """
    The VPC ID.
    """
    
    vswitch_name?: str
    """
    The name of the switch. Defaults to null.
    """
    
    zone_id?: str
    """
    The AZ for the switch.
    """