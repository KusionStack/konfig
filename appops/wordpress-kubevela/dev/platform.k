import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_clouds.alicloud_backend.alicloud_config
import base.pkg.kusion_models.kube.metadata

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
# And platform.k is for the configurations in concern of platform developers. 

_alicloudResourceName = "{}-{}".format(metadata.__META_APP_NAME, metadata.__META_ENV_TYPE_NAME).lower()
_alicloudDependencyPrefix = "$kusion_path." + alicloud_config.alicloudProvider.namespace + ":" + alicloud_config.alicloudProvider.name + ":"

# defination of wordpress application frontend model
wordpress: frontend.Server {
    # specify to render the k8s resources in the form of KubeVela Application
    renderType = "KubeVelaApplication"

    # add environment variable in main container with implicit alicloud resource dependency
    mainContainer: {
        env += [
            {
                name = "WORDPRESS_DB_HOST"
                value = _alicloudDependencyPrefix + alicloud_config.alicloudDBConnectionMeta.type + ":" + _alicloudResourceName + ".connection_string"
            }
        ]
    }
}
