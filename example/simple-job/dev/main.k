import kam.v1.app_configuration as ac
import kam.v1.workload as wl
import kam.v1.workload.container as c

helloworld: ac.AppConfiguration {
    workload: wl.Job {
        containers: {
            "busybox": c.Container {
                # The target image
                image: "busybox:1.28"
                # Run the following command as defined
                command: ["/bin/sh", "-c", "echo hello"]
            }
        }
        # Run every hour.
        schedule: "0 * * * *"
    }
}