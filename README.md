# kubernetes

```bash
cd vault && terraform init && cd -
cd k8s   && terraform init && cd -

terraform -chdir=k8s apply -var cluster_name="cluster-1" -auto-approve
```