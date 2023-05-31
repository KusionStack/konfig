import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.service
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.frontend.secret
import base.pkg.kusion_models.kube.frontend.volume as v
import base64

wordpress: frontend.Server {
    name = "wordpress-deployment"

    volumes = [
        {
            name = "wordpress-persistent-storage"
            volumeSource = v.EmptyDir{}
            mounts = [
                v.Mount {
                    container = "wordpress"
                    path = "/var/www/html"
                }
            ]
        }
    ]

    secrets = [
        secret.Secret {
            name = "mysql-pass"
            data = {
                "password" = base64.encode(option("db_password"))
            }
            type = "Opaque"
        }
    ]

    mainContainer = container.Main {
        name = "wordpress"
        env = [
            {
                name = "WORDPRESS_DB_PASSWORD"
                valueFrom = {
                    secretKeyRef = {
                        key = "password"
                        name = "mysql-pass"
                    }
                }
            }
        ]
        ports = [
            {
                name = "wordpress"
                containerPort = 80
            }
        ]
    }

    services = [
        service.Service {
            name = "wordpress"
            type = "ClusterIP"
            ports = [
                {
                    port = 80
                }
            ]
        }
    ]
}
