import base.pkg.kusion_clouds.alicloud

#create vpc
alicloud.AlicloudVPC {
    name = "alicloud_vpc"
    cidr_block = "172.16.0.0/12"
}

#create vswitch
alicloud.AlicloudVswitch {
    vpc_id = "$kusion_path.aliyun:alicloud:alicloud_vpc:alicloud_vpc.id"
    cidr_block        = "172.16.0.0/21"
    availability_zone = "cn-beijing-a" 
    name = "alicloud_vswitch"
}


#create alicloud ack
alicloud.AlicloudManagedKubernetes {
    name               = "kusion-ack"
    cluster_spec       = "ack.pro.small"
    version            = "1.24.6-aliyun.1"
    worker_vswitch_ids = ["$kusion_path.aliyun:alicloud:alicloud_vswitch:alicloud_vswitch.id"]
    pod_cidr                  = "10.10.0.0/16"
    # The Service CIDR block. The Service CIDR block cannot be the same as the VPC CIDR block or the CIDR blocks of other Kubernetes clusters in the VPC. You cannot change the Service CIDR block after the cluster is created. 
    service_cidr              = "192.168.0.0/16"
    slb_internet_enabled      = True
}



