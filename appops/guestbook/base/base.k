import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.frontend.service
import base.pkg.kusion_models.kube.templates.resource as res_tpl

# Application Configuration
guestbookFrontend: frontend.Server {
    name = "frontend"
    # Main Container Configuration
    mainContainer = container.Main {
        name = "php-redis"
        env = [
            {
                name = "GET_HOSTS_FROM"
                value = "dns"
            }
        ]
        ports = [{containerPort = 80}]
    }
    schedulingStrategy.resource = res_tpl.tiny
    services = [
        service.Service {
            ports = [
                {
                    "port" = 80
                }
            ]
        }
    ]
}

redisLeader: frontend.Server {
    name = "redis-leader"
    # Main Container Configuration
    mainContainer = container.Main {
        ports = [{containerPort = 6379}]
    }
    image = "docker.io/redis:6.0.5"
    schedulingStrategy.resource = res_tpl.tiny
    services = [
        service.Service {
            ports = [
                {
                    "port" = 6379
                }
            ]
        }
    ]
}

redisFollower: frontend.Server {
    name = "redis-follower"
    # Main Container Configuration
    mainContainer = container.Main {
        ports = [{containerPort = 6379}]
    }
    image = "gcr.io/google_samples/gb-redis-follower:v2"
    schedulingStrategy.resource = res_tpl.tiny
    services = [
        service.Service {
            ports = [
                {
                    "port" = 6379
                }
            ]
        }
    ]
}