import kam.v1.app_configuration as ac
import service
import service.container as c
import network as n
import mysql as m

# main.k declares customized configurations for prod stacks.
wordpress: ac.AppConfiguration {
    workload: service.Service {
        containers: {
            wordpress: c.Container {
                image: "wordpress:6.3"
                env: {
                    "WORDPRESS_DB_HOST": "$(KUSION_DB_HOST_WORDPRESS_MYSQL)"
                    "WORDPRESS_DB_USER": "$(KUSION_DB_USERNAME_WORDPRESS_MYSQL)"
                    "WORDPRESS_DB_PASSWORD": "$(KUSION_DB_PASSWORD_WORDPRESS_MYSQL)"
                    "WORDPRESS_DB_NAME": "mysql"
                }
                resources: {
                    "cpu": "500m"
                    "memory": "512Mi"
                }
            }
        }
        replicas: 1
    }
    accessories: {
        "network": n.Network {
            ports: [
                n.Port {
                    port: 80
                }
            ]
        }
        "mysql": m.MySQL {
            type: "cloud"
            version: "8.0"
        }
    }
}
