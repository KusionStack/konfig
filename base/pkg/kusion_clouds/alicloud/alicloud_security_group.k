schema AlicloudSecurityGroup:	
    description?: str
    """
    The security group description. Defaults to null.
    """
    
    id?: str
    """
    The ID of the security group
    """
    
    inner_access?: bool
    """
    Field 'inner_access' has been deprecated from provider version 1.55.3. Use 'inner_access_policy' replaces it.
    """
    
    inner_access_policy?: str
    """
    Whether to allow both machines to access each other on all ports in the same security group. Valid values: ["Accept", "Drop"]
    """
    
    name?: str
    """
    The name of the security group. Defaults to null.
    """
    
    resource_group_id?: str
    """
    The Id of resource group which the security_group belongs.
    """
    
    security_group_type?: str
    """
    The type of the security group. Valid values: normal: basic security group. enterprise: advanced security group For more information.
    """
    
    tags?: {str:str}
    """
    A mapping of tags to assign to the resource.
    """

    vpc_id?: str
    """
    The VPC ID.
    """