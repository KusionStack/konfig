import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.service
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.frontend.secret
import base.pkg.kusion_models.kube.frontend.volume as v
import base.pkg.kusion_models.kube.frontend.storage

mysql: frontend.Server {
    name = "wordpress-mysql"
    selector = {
        "app" = "wordpress-mysql"
        "tier" = "database"
    }
    # Pod metadata
    podMetadata = {
        labels: {
            "app" = "wordpress-mysql"
            "tier" = "database"
        }
    }

    volumes = [
        {
            name = "mysql-persistent-storage"
            volumeSource = v.EmptyDir {}
            mounts = [
                v.Mount {
                    container = "mysql"
                    path = "/var/lib/mysql"
                }
            ]
        }

    ]

    secrets = [
        secret.Secret {
            name = "mysql-pass"
            data = {
                "password" = "MTIzNDU2"
            }
            type = "Opaque"
        }
    ]

    mainContainer = container.Main {
        name = "mysql"
        env = [
            {
                name = "MYSQL_ROOT_PASSWORD"
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
                name = "mysql"
                containerPort = 3306
            }
        ]
    }

    services = [
        service.Service {
            name = "wordpress-mysql"
            clusterIP = "None"
            selector = {
                "app" = "wordpress-mysql"
                "tier" = "database"
            }
            ports = [
                {
                    port = 3306
                }
            ]
        }
    ]
}

wordpress: frontend.Server {
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

    mainContainer = container.Main {
        name = "wordpress"
        env = [
            {
                name = "WORDPRESS_DB_HOST"
                value = "wordpress-mysql"
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
            type = "LoadBalancer"
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
    
    storage = storage.ObjectStorage {
        objectStorageType = "aliyun_oss"
        objectStorageAttr = storage.StorageAttr {
            bucket = "kusion-oss"
            acl    = "public-read"
        }
    }
}
