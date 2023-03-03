import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.service
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.frontend.secret
import base.pkg.kusion_models.kube.frontend.volume as v
import base.pkg.kusion_models.kube.frontend.storage

wordpress = frontend.Server {
    name = "wordpress-deployment"
    selector = {
        "app" = "wordpress-mysql"
        "tier" = "frontend"

    }
    # Pod metadata
    podMetadata = {
        labels: {
            "app" = "wordpress-mysql"
            "tier" = "frontend"
        }
    }

    volumes = [
        {
            name = "wordpress-persistent-storage"
            volumeSource = v.EmptyDir {}
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
                "password" = "S3VzaW9uMTIzNDU2"
            }
            type = "Opaque"
        }
    ]

    mainContainer = container.Main {
        name = "wordpress"
        env = [
            {
                name = "WORDPRESS_DB_HOST"
                value = "$kusion_path.aliyun:alicloud:alicloud_db_connection:wordpress-deployment-connection.connection_string"
            }
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
            selector = {
                "app" = 'wordpress-mysql'
                "tier" = 'frontend'
            }
            ports = [
                {
                    port = 80
                }
            ]
        }
    ]
}
