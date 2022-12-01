import base.pkg.kusion_models.kube.frontend

jobConfiguration: frontend.Job {
    activeDeadlineSeconds = 100
    backoffLimit = 5
    completions = 5
    parallelism = 1
    ttlSecondsAfterFinished = 100
    manualSelector = True
    selector = {
        "foo": "bar"
    }
    podMetadata.labels: {
        "foo" = "bar"
    }
}