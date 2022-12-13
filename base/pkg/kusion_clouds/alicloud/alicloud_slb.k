schema AlicloudSLB:
    address?: str
    """
    Specify the IP address of the private network for the SLB instance, which must be in the destination CIDR block of the corresponding switch.
    """
    
    address_ip_version?: str
    """
    The IP version of the SLB instance to be created, which can be set to ipv4 or ipv6 . Default to ipv4. Now, only internet instance support ipv6 address.
    """
    
    address_type?: str
    """
    The network type of the SLB instance. Valid values: ["internet", "intranet"]. If load balancer launched in VPC, this value must be intranet.
    internet: After an Internet SLB instance is created, the system allocates a public IP address so that the instance can forward requests from the Internet.
    intranet: After an intranet SLB instance is created, the system allocates an intranet IP address so that the instance can only forward intranet requests.
    """
    
    bandwidth?: int
    """
    Valid value is between 1 and 1000, If argument internet_charge_type is PayByTraffic, then this value will be ignore.
    """
    
    delete_protection?: str
    """
    Whether enable the deletion protection or not. on: Enable deletion protection. off: Disable deletion protection. Default to off. Only postpaid instance support this function.
    """
    
    id?: str
    """
    The ID of the load balancer.
    """
    
    instance_charge_type?: str
    """
    Field instance_charge_type has been deprecated from provider version 1.124.0 New field payment_type instead.
    """
    
    internet?: bool
    """
    Field internet has been deprecated from provider version 1.124.0 New field address_type instead.
    """
    
    internet_charge_type?: str
    """
    Valid values are PayByBandwidth, PayByTraffic. If this value is PayByBandwidth, then argument address_type must be internet. Default is PayByTraffic. If load balancer launched in VPC, this value must be PayByTraffic. Before version 1.10.1, the valid values are paybybandwidth and paybytraffic.
    """
    
    load_balancer_name?: str
    """
    The name of the SLB. This name must be unique within your AliCloud account
    """
    
    load_balancer_spec?: str
    """
    The specification of the Server Load Balancer instance. Default to empty string indicating it is "Shared-Performance" instance. Launching "Performance-guaranteed" instance, it is must be specified and it valid values are: slb.s1.small, slb.s2.small, slb.s2.medium, slb.s3.small, slb.s3.medium, slb.s3.large and slb.s4.large.
    """
    
    master_zone_id?: str
    """
    The primary zone ID of the SLB instance. If not specified, the system will be randomly assigned.
    """
    
    modification_protection_reason?: str
    """
    The reason of modification protection. It's effective when modification_protection_status is ConsoleProtection.
    """
    
    modification_protection_status?: str
    """
    The status of modification protection. Valid values: ConsoleProtection and NonProtection. Default value is NonProtection.
    """
    
    name?: str
    """
    Field name has been deprecated from provider version 1.123.1 New field load_balancer_name instead.
    """
    
    payment_type?: str
    """
    The billing method of the load balancer. Valid values are PayAsYouGo and Subscription. Default to PayAsYouGo.
    """
    
    period?: int
    """
    The duration that you will buy the resource
    """
    
    resource_group_id?: str
    """
    The Id of resource group which the SLB belongs.
    """
    
    slave_zone_id?: str
    """
    The standby zone ID of the SLB instance. If not specified, the system will be randomly assigned. You can query the primary and standby zones in a region by calling the DescribeZone API.
    """
    
    specification?: str
    """
    Field specification has been deprecated from provider version 1.123.1 New field load_balancer_spec instead.
    """
    
    status?: str
    """
    The status of slb load balancer. Valid values: active and inactice. The system default value is active.
    """
    
    tags?: {str:str}
    """
    A mapping of tags to assign to the resource. The tags can have a maximum of 10 tag for every load balancer instance.
    """
    
    vswitch_id?: str
    """
    The VSwitch ID to launch in. If address_type is internet, it will be ignore.
    """