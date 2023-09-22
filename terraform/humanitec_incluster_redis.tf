# https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition
resource "humanitec_resource_definition" "in-cluster-redis" {
  #count      = var.humanitec_env_type == "development" && var.enable_redis ? 1 : 0
  id          = "in-cluster-redis"
  name        = "in-cluster-redis"
  type        = "redis"
  driver_type = "humanitec/template"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        init = <<EOL
name: redis
port: 6379
EOL
        manifests = <<EOL
deployment.yaml:
  location: namespace
  data:
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: {{ .init.name }}
    spec:
      selector:
        matchLabels:
          app: {{ .init.name }}
      template:
        metadata:
          labels:
            app: {{ .init.name }}
        spec:
          securityContext:
            fsGroup: 1000
            runAsGroup: 1000
            runAsNonRoot: true
            runAsUser: 1000
            seccompProfile:
              type: RuntimeDefault
          containers:
          - name: {{ .init.name }}
            securityContext:
              allowPrivilegeEscalation: false
              capabilities:
                drop:
                  - ALL
              privileged: false
              readOnlyRootFilesystem: true
            image: redis:alpine
            ports:
            - containerPort: {{ .init.port }}
            volumeMounts:
            - mountPath: /data
              name: redis-data
          volumes:
          - name: redis-data
            emptyDir: {}
service.yaml:
  location: namespace
  data:
    apiVersion: v1
    kind: Service
    metadata:
      name: {{ .init.name }}
    spec:
      type: ClusterIP
      selector:
        app: {{ .init.name }}
      ports:
      - name: tcp-redis
        port: {{ .init.port }}
        targetPort: {{ .init.port }}
EOL
        outputs   = <<EOL
host: {{ .init.name }}
port: {{ .init.port }}
EOL
      }
    })
  }

  lifecycle {
    ignore_changes = [
      criteria
    ]
  }
}

resource "humanitec_resource_definition_criteria" "in-cluster-redis" {
  #count                  = var.humanitec_env_type == "development" && var.enable_redis ? 1 : 0
  resource_definition_id  = humanitec_resource_definition.in-cluster-redis[count.index].id
}