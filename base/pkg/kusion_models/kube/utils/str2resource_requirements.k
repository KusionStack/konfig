import base.pkg.kusion_models.kube.frontend.resource as res

import regex

schema Str2ResourceRequirements[resourcePara: str | res.Resource]:
    resourceStr?: str = resourcePara as str if typeof(resourcePara) == "str" else None
    resourceUnit?: res.Resource = resourcePara as res.Resource if typeof(resourcePara) == "Resource" else None
    schedulingResourceItems: [str] = resourceStr?.split(",") or []

    resource: [{str:}] = [{
        cpu = {
            requests = (item.split("=")?[1] if len(item.split("=")) > 1 else item.split("<")?[0])?.strip()
            limits = (item.split("=")?[1] if len(item.split("=")) > 1 else item.split("<")?[-1])?.strip()
        }
    } if "cpu" in item else ({
        memory = {
            requests = (item.split("=")?[1] if len(item.split("=")) > 1 else item.split("<")?[0])?.strip()
            limits = (item.split("=")?[1] if len(item.split("=")) > 1 else item.split("<")?[-1])?.strip()
        }
    } if "memory" in item else ({
        disk = {
            requests = (item.split("=")?[1] if len(item.split("=")) > 1 else item.split("<")?[0])?.strip()
            limits = (item.split("=")?[1] if len(item.split("=")) > 1 else item.split("<")?[-1])?.strip()
        }
    } if "disk" in item else Undefined)) for item in schedulingResourceItems]

    result: {str:} = {
        requests = {
            cpu = resource?[0]?.cpu?.requests or resource?[1]?.cpu?.requests or resource?[2]?.cpu?.requests
            memory = resource?[0]?.memory?.requests or resource?[1]?.memory?.requests or resource?[2]?.memory?.requests
            "ephemeral-storage" = resource?[0]?.disk?.requests or resource?[1]?.disk?.requests or resource?[2]?.disk?.requests
        }
        limits = {
            cpu = resource?[0]?.cpu?.limits or resource?[1]?.cpu?.limits or resource?[2]?.cpu?.limits
            memory = resource?[0]?.memory?.limits or resource?[1]?.memory?.limits or resource?[2]?.memory?.limits
            "ephemeral-storage" = resource?[0]?.disk?.limits or resource?[1]?.disk?.limits or resource?[2]?.disk?.limits
        }
    } if resourceStr else {
        requests = {
            cpu = str(resourceUnit.cpu)
            memory = str(resourceUnit.memory)
            "ephemeral-storage" = str(resourceUnit.disk)
        }
        limits = {
            cpu = str(resourceUnit.cpu)
            memory = str(resourceUnit.memory)
            "ephemeral-storage" = str(resourceUnit.disk)
        }
    }

    check:
        regex.match(result?.requests?.cpu, r"^([+-]?[0-9.]+)([m]*[-+]?[0-9]*)$") if result?.requests?.cpu, "cpu must match specific regular expression"
        regex.match(result?.requests?.memory, r"^([0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$") if result?.requests?.memory, "memory must match specific regular expression"
        regex.match(result?.requests?["ephemeral-storage"], r"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$") if result?.requests?["ephemeral-storage"], "disk must match specific regular expression"
        regex.match(result?.limits?.cpu, r"^([+-]?[0-9.]+)([m]*[-+]?[0-9]*)$") if result?.limits?.cpu, "cpu must match specific regular expression"
        regex.match(result?.limits?.memory, r"^([0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$") if result?.limits?.memory, "memory must match specific regular expression"
        regex.match(result?.limits?["ephemeral-storage"], r"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$") if result?.limits?["ephemeral-storage"], "disk must match specific regular expression"
