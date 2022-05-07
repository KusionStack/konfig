import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.frontend.container
import base.pkg.kusion_models.kube.frontend.container.env as e
import base.pkg.kusion_models.kube.frontend.container.port as cp
import base.pkg.kusion_models.kube.frontend.container.probe as p

# The application configuration in stack will overwrite 
# the configuration with the same attribute in base.
appConfiguration: frontend.Server {
    # Main container configuration
    mainContainer: container.Main {
        # 主容器名称，可选
        name = "main"
        # 主容器启动命令，可选
        command = ["/home/admin/server.sh"]
        # 主容器启动参数，可选
        args = ["start"]
        # 主容器环境变量，可选
        env = [
            e.Env {
                name = "app.version"
                value = "v1.0.0"
            }
        ]
        envFrom = [
            e.EnvFromSource {
                configMapRef = "my-configmap"
            }
        ]
        # 主容器端口，可选
        ports = [
            cp.ContainerPort {
                containerPort = 12201
                protocol = "TCP"
            }
        ]
        # 主容器存活探针，可选
        livenessProbe = p.Probe {
            failureThreshold = 3
            initialDelaySeconds = 30
            periodSeconds = 5
            successThreshold = 1
            timeoutSeconds = 10
            handler = p.Exec {
                command = ["/bin/sh", "-c", "echo livenessProbe"]
            }
        }
        # 主容器就绪探针，可选
        readinessProbe = p.Probe {
            failureThreshold = 3
            initialDelaySeconds = 30
            periodSeconds = 5
            successThreshold = 2
            timeoutSeconds = 10
            handler = p.Exec {
                command = ["/bin/sh", "-c", "echo readinessProbe"]
            }
        }
        # 主容器启动探针, 启动探针探测成功之后存活探测才开始工作，可选
        startupProbe = p.Probe {
            failureThreshold = 3
            initialDelaySeconds = 30
            periodSeconds = 5
            successThreshold = 2
            timeoutSeconds = 10
            handler = p.Exec {
                command = ["/bin/sh", "-c", "echo startupProbe"]
            }
        }
    }
}
