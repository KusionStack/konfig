schema AWSSecurityGroup: 
    description?: str

    egress?: [egress]

    ingress?: [ingress]

    name_prefix?: str

    name?: str

    revoke_rules_on_delete?: bool = false

    tags?: {str:str}

    vpc_id?: str

schema ingress: 
    description?: str

    from_port?: int

    to_port?: int

    protocol?: str

    cidr_blocks?: [str]

    ipv6_cidr_blocks: [str] = []

    prefix_list_ids: [str] = []

    security_groups: [str] = []

    self: bool = false

schema egress: 
    description?: str

    from_port?: int

    to_port?: int

    protocol?: str

    cidr_blocks?: [str]

    ipv6_cidr_blocks?: [str]

    prefix_list_ids?: [str] 

    security_groups?: [str] 

    self: bool = false
