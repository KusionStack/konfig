import base.pkg.kusion_kubevela.v1beta1
import manifests

manifests.yaml_stream([v1beta1.Application {
    metadata.name = "webservice-app"
    spec.components = [{
        name = "front-end"
        type = "webservice"
        properties = {
            image = "oamdev/testapp:v1"
            cmd = ["node", "server.js"]
            ports = [{port = 8080, expose = True}]
            exposeType = "NodePort"
            cpu = "0.5"
            memory = str(512Mi)
        }
        traits = [
            {
                type = "scaler"
                properties.replicas = 1
            }
        ]
    }]
}])
