import catalog.models.schema.v1 as ac

# main.k declares customized configurations for dev stack.
echoserver: ac.AppConfiguration {
    workload.containers.server: {
        # dev stack use latest echoserver image
        image = "cilium/echoserver"
    }
}