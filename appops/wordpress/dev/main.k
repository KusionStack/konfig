import base.pkg.kusion_models.kube.frontend

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
mysql: frontend.Server {
    image = "mysql:5.6"
}
wordpress: frontend.Server {
    image = "wordpress:4.8-apache"
}
