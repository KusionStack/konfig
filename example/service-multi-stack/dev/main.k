import kam.v1.app_configuration as ac
import service
import service.container as c

# main.k declares customized configurations for dev stack.
echoserver: ac.AppConfiguration {
    workload: service.Service {
        containers: {
            "server": c.Container {
                # dev stack use latest echoserver image
                image = "cilium/echoserver"
            }
        }
    }
}