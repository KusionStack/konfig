import base.pkg.kusion_models.kube.frontend.server
import base.pkg.kusion_clouds.alicloud
import base.pkg.kusion_clouds.alicloud_backend

schema StorageBackend[config: server.Server]: 
    assert config, "input config must be specified and can't be empty or None or Undefined"
    provider: [any]

    if config.storage:
        if config.storage.objectStorageType == "aliyun_oss":
            aliyunStorage = alicloud.AlicloudOSSBucket {
                bucket = config.storage.objectStorageAttr.bucket
                acl    = config.storage.objectStorageAttr.acl
            }
            provider = [*provider, alicloud_backend.OSSRender(aliyunStorage).provider] 