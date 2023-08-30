# google-cloud-reference-architecture

In Humanitec:

```mermaid
flowchart LR
  subgraph Humanitec
    subgraph Resources
      namespace>custom-namespace]
      logging>custom-gcp-logging]
      in-cluster-mysql>in-cluster-mysql]
      gke-cluster>gke-cluster]
    end
    subgraph Apps
      direction LR
      subgraph App
        subgraph Environment
        end
      end
    end
    subgraph Environment Types
      subgraph Environment
      end
    end
  end
```

In Google Cloud:

FIXME

In GitHub:

```mermaid
flowchart LR
  subgraph GitHub
    subgraph Org
      subgraph Secrets
        HUMANITEC_ORG
        HUMANITEC_TOKEN
        GCP_GAR_NAME
        GCP_GAR_HOST
        GCP_GAR_WRITER_KEY
      end
    end
  end
```

For each Environment, just change this value:
```bash
HUMANITEC_ENVIRONMENT_TYPE=development
HUMANITEC_APP=FIXME

GITHUB_ORG=FIXME
GITHUB_REPOSITORY=FIXME
GITHUB_TOKEN=FIXME

GOOGLE_PROJECT_ID=FIXME
```

```bash
cd terraform/environment

gcloud auth application-default login

terraform workspace new ${ENVIRONMENT_TYPE}
terraform workspace select ${ENVIRONMENT_TYPE}

terraform init -upgrade

terraform plan \
    -var humanitec_credentials="{\"organization\"=\"${HUMANITEC_ORG}\", \"token\"=\"${HUMANITEC_TOKEN}\"}" \
    -var humanitec_app_name=${HUMANITEC_APP} \
    -var github_credentials="{\"organization\"=\"${GITHUB_ORG}\", \"repository\"=\"${GITHUB_REPOSITORY}\", \"token\"=\"${GITHUB_TOKEN}\"}" \
    -var gcp_project_id=${GOOGLE_PROJECT_ID} \
    -var humanitec_env_type=${HUMANITEC_ENVIRONMENT_TYPE} \
    -out tfplan

terraform apply \
    tfplan
```