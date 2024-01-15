# Tests

```bash
APP=FIXME
ENVIRONMENT=FIXME
```

## Deploy with GCS

```bash
make with-gcs
```

Should get successfull requests in the logs:
```bash
kubectl logs \
    -l app.kubernetes.io/name=gcs-workload \
    -n ${ENVIRONMENT}-${APP}
```

Should return a KSA with the WI annotation:
```bash
kubectl get sa gcs-workload \
    -n ${ENVIRONMENT}-${APP} \
    -o yaml
```

Should return a GSA:
```bash
gcloud iam service-accounts list | grep gcs-workload
```

## Deploy without GCS

```bash
make without-gcs
```

Should return a KSA without the WI annotation:
```bash
kubectl get sa no-gcs-workload \
    -n ${ENVIRONMENT}-${APP} \
    -o yaml
```

Shouldn't return a GSA:
```bash
gcloud iam service-accounts list | grep no-gcs-workload
```