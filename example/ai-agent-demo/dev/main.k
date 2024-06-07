# The configuration codes in perspective of developers. 
import kam.v1.app_configuration as ac
import service as svc
import service.secret as sec
import service.container as c
import opensearch.opensearch as o

agent: ac.AppConfiguration {
    # Declare the workload configurations.
    workload: svc.Service {
        containers: {
            opensearch: c.Container {
                image: "kusionstack/ai-agent-demo:v0.1.0"
                env: {
                    # "OPENAI_API_KEY": "secret://ai-agent/OPENAI_API_KEY"
                    # "RAG_ENABLED": "true"
                    # "OPEN_SEARCH_AK": "secret://ai-agent/OPEN_SEARCH_AK"
                    # "OPEN_SEARCH_SK": "secret://ai-agent/OPEN_SEARCH_SK"
                }
            }
        }
        # Secrets used to retrieve secret data from AWS Secrets Manager
        secrets: {
            "ai-agent": sec.Secret {
                type: "external"
                data: {
                    # replace all references with your own tokens
                    # "OPENAI_API_KEY": "ref://ai-agent/OPENAI_API_KEY"
                    # "OPEN_SEARCH_AK": "ref://ai-agent/OPEN_SEARCH_AK"
                    # "OPEN_SEARCH_SK": "ref://ai-agent/OPEN_SEARCH_SK"
                }
            }
        }
    }
    # Declare the openSearch module configurations.
    accessories: {
        "opensearch": o.OpenSearch {
            domainName: "ai-agent-demo"
            engineVersion: "OpenSearch_2.13"
        }
    }
}