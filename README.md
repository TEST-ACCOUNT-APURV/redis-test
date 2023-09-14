# [Beta] Google Cloud Reference Architecture for Humanitec

This is not yet the official Google Reference Architecture for Humanitec. This is currently tested as part of the Humanitec POV on Google Cloud. Feedback are more than welcome!

[![ci](https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture/actions/workflows/ci.yaml/badge.svg)](https://github.com/Humanitec-DemoOrg/google-cloud-reference-architecture/actions/workflows/ci.yaml)

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
        subgraph app-env [Environment]
        end
      end
    end
    subgraph Environment Types
      subgraph env-type [Environment]
      end
    end
  end
```

In Google Cloud:

```mermaid
flowchart LR
  subgraph Google Cloud
    subgraph gke [Google Kubernetes Engine]
      ingress-nginx
    end
    subgraph gar [Google Artifact Registry]
      containers
    end
    subgraph cloud-nat [Cloud NAT]
    end
    subgraph cloud-logging [Cloud Logging]
    end
    subgraph Google Service Accounts
      gke_nodes
      github_gar_writer_access
      humanitec_gke_logging_access
      humanitec_gke_cluster_access
    end
    gke-->gke_nodes
    gke_nodes-->cloud-nat
    gke_nodes-->gar
    humanitec_gke_logging_access-->cloud-logging
    gke-->cloud-logging
    github_gar_writer_access-->gar
    humanitec_gke_cluster_access-->gke
    public-ip[Public IP address]-->ingress-nginx
  end
```

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
      subgraph Variables
        CLOUD_PROVIDER
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
cd terraform

gcloud auth application-default login

terraform workspace new ${HUMANITEC_ENVIRONMENT_TYPE}
terraform workspace select ${HUMANITEC_ENVIRONMENT_TYPE}

terraform init -upgrade

terraform validate

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