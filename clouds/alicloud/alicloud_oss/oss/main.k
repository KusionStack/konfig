import base.pkg.kusion_clouds.alicloud

#create oss
alicloud.AlicloudOSSBucket {
    bucket = "kusion-oss"
    acl    = "private"
}
