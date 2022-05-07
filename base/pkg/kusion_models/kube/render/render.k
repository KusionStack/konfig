import base.pkg.kusion_models.kube.frontend
import base.pkg.kusion_models.kube.backend

__renderServerFrontendInstances__ = [inst for inst in frontend.Server.instances() if typeof(inst) == "Server"]
__renderServerBackendInstances__ = [backend.ServerBackend(inst) for inst in __renderServerFrontendInstances__]

__renderJobFrontendInstances__ = [inst for inst in frontend.Job.instances() if typeof(inst) == "Job"]
__renderJobBackendInstances__ = [backend.JobBackend(inst) for inst in __renderJobFrontendInstances__]
__renderFrontendInstances__ = [
    *__renderServerFrontendInstances__
    *__renderJobFrontendInstances__
]
__renderBackendInstances__ = [
    *__renderServerBackendInstances__
    *__renderJobBackendInstances__
]

renderKubeKubernetes = [
    _inst?.kubernetes | {__settings__: {output_type = "STANDALONE"}} \
    for _inst in __renderBackendInstances__ if _inst?.kubernetes
]
