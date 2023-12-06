import catalog.models.schema.v1 as ac
import catalog.models.schema.v1.trait as t
import catalog.models.schema.v1.workload as wl
import catalog.models.schema.v1.workload.container as c
import catalog.models.schema.v1.workload.container.probe as p
import catalog.models.schema.v1.workload.secret as sec
import catalog.models.schema.v1.workload.network as n
import catalog.models.schema.v1.monitoring as m
import catalog.models.schema.v1.accessories.database as db

# main.k declares reusable configurations for all stacks.
wordpress: ac.AppConfiguration {
    # the main workload configurations
    workload: wl.Service {
        containers: {
            wordpress: c.Container {
                image = "wordpress:4.8-apache"
                env: {
                    "WORDPRESS_DB_HOST": "secret://wordpress-db/hostAddress"
                    "WORDPRESS_DB_PASSWORD": "secret://wordpress-db/password"
                }
                resources: {
                    "cpu": "500m"
                    "memory": "512Mi"
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
    # database accessory configurations
    database: db.Database {
        type: "alicloud"
        engine: "MySQL"
        version: "5.7"
        size: 20
        instanceType: "mysql.n2.serverless.1c"
    }
}