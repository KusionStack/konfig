import base.pkg.kusion_clouds.alicloud
# import sigma.base.pkg.kusion_models.commons

# create vpc
alicloud.AlicloudVPC {
    vpc_name = "alicloud_vpc"
    cidr_block = "172.16.0.0/16"
}

# create vswitch
alicloud.AlicloudVswitch {
    vpc_id = "$kusion_path.aliyun:alicloud:alicloud_vpc:alicloud_vpc.id"
    cidr_block        = "172.16.0.0/21"
    availability_zone = "cn-beijing-b" 
    vswitch_name = "alicloud_vswitch"
}

# create secutirygroup 
alicloud.AlicloudSecurityGroup {
    name        = "alicloud_security_group"
    description = "alicloud-security-group"
    vpc_id = "$kusion_path.aliyun:alicloud:alicloud_vpc:alicloud_vpc.id"
}

# create instance
alicloud.AlicloudInstance {
    availability_zone = "cn-beijing-b"
    security_groups = ["$kusion_path.aliyun:alicloud:alicloud_security_group:alicloud_security_group.id"]

    instance_type        = "ecs.n2.small"
    internet_charge_type = "PayByTraffic"
    system_disk_category = "cloud_efficiency"
    image_id             = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
    instance_name        = "kusion-alicloud-instance"
    vswitch_id = "$kusion_path.aliyun:alicloud:alicloud_vswitch:alicloud_vswitch.id"
    password = "Demokusion"
}

alicloud.AlicloudInstance {
    availability_zone = "cn-beijing-b"
    security_groups = ["$kusion_path.aliyun:alicloud:alicloud_security_group:alicloud_security_group.id"]

    instance_type        = "ecs.n2.small"
    internet_charge_type = "PayByTraffic"
    system_disk_category = "cloud_efficiency"
    image_id             = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
    instance_name        = "kusion-alicloud-instance2"
    vswitch_id = "$kusion_path.aliyun:alicloud:alicloud_vswitch:alicloud_vswitch.id"
    password = "Demokusion"
}
