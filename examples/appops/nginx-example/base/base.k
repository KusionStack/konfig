import konfig.models.kube.frontend
import konfig.models.kube.frontend.service
import konfig.models.kube.frontend.container

# Application Configuration
appConfiguration: frontend.Server {
    # Main Container Configuration
    mainContainer = container.Main {
        ports = [
            {containerPort = 80}
        ]
        env.MY_ENV: {
            value = "MY_VALUE"
        }
    }
    image = "nginx:1.7.8"
    services = [
        service.Service {
            name = "nginx"
            type = "NodePort"
            ports = [
                {
                    nodePort = 30201
                    port = 80
                    targetPort = 80
                }
            ]
        }
    ]
}
