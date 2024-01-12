import catalog.models.schema.v1 as ac
import catalog.models.schema.v1.workload as wl
import catalog.models.schema.v1.workload.container as c
import catalog.models.schema.v1.workload.network as n
import catalog.models.schema.v1.accessories.mysql

# main.k declares customized configurations for prod stack. 
wordpress: ac.AppConfiguration {
    workload: wl.Service {
        containers: {
            wordpress: c.Container {
                image: "wordpress:6.3"
                env: {
                    "WORDPRESS_DB_HOST": "$(KUSION_DB_HOST_WORDPRESS_MYSQL)"
                    "WORDPRESS_DB_USER": "$(KUSION_DB_USERNAME_WORDPRESS_MYSQL)"
                    "WORDPRESS_DB_PASSWORD": "$(KUSION_DB_PASSWORD_WORDPRESS_MYSQL)"
                    "WORDPRESS_DB_NAME": "mysql"
                }
            }
        }
        replicas: 1
        ports: [
            n.Port {
                port: 80
            }
        ]
    }
    database: {
        wordpress: mysql.MySQL {
            type: "local"
            version: "8.0"
        }
    }
}
