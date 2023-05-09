import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_clouds.alicloud_backend.alicloud_config

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
# And platform.k is for the configurations in concern of platform developers. 

_alicloudProviderName = alicloud_config.alicloudProvider.name
_alicloudProviderNamespace = alicloud_config.alicloudProvider.namespace
_alicloudDBConnectionType = alicloud_config.alicloudDBConnectionMeta.type

_alicloudResourceName = "{}-{}".format(metadata.__META_APP_NAME, metadata.__META_ENV_TYPE_NAME).lower()
_alicloudDependencyPrefix = "{}{}:{}:".format("$kusion_path.", _alicloudProviderNamespace, _alicloudProviderName)

# defination of wordpress application frontend model
wordpress: frontend.Server {
    # add environment variable in main container with implicit alicloud resource dependency
    mainContainer.env += [
        {
            name = "WORDPRESS_DB_HOST"
            value = "{}{}:{}{}".format(_alicloudDependencyPrefix, _alicloudDBConnectionType, _alicloudResourceName,  ".connection_string")
        }
    ]
}
