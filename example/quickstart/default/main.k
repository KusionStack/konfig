# The configuration codes in perspective of developers.
import kam.v1.app_configuration as ac
import service
import service.container as c
import network as n

# `main.k` declares the customized configuration codes for default stack. 
# 
# Please replace the ${APPLICATION_NAME} with the name of your application, and complete the 
# 'AppConfiguration' instance with your own workload and accessories.
quickstart: ac.AppConfiguration {
    workload: service.Service {
        containers: {
            quickstart: c.Container {
                image: "kusionstack/kusion-quickstart:latest"
            }
        }
    }
    accessories: {
        "network": n.Network {
            ports: [
                n.Port {
                    port: 8080
                }
            ]
        }
    }
}
