# kubernetes

```bash
cd vault && terraform init && cd -
cd k8s   && terraform init && cd -

CLUSTER_NAME="cluster-2" terraform -chdir=k8s apply -var cluster_name="$CLUSTER_NAME" -var vault_server="http:/auth.example.com"  -auto-approve  -state states/$CLUSTER_NAME
```

```
Вся информация по сертификатам находится в файле vault.variables.tf:

ssl.global-args.issuers-args                                            - там описаны дефолтные значения для vault roles
ssl.global-args.key-keeper-args                                         - описаны дефолтные значения для заказа сертификата
ssl.intermediate                                                        - словарь со всеми intermediate CA
ssl.intermediate[“*”].issuers                                           - словарь со всеми vault role в рамках CA
ssl.intermediate[“*”].issuers[“*”].backend                              - базовый путь vault role (путь к сейфу pki)
ssl.intermediate[“*”].issuers[“*”].issuer-args                          - разрешенные значения для vault role *(мержится с global-args.issuers-args
ssl.intermediate[“*”].issuers[“*”].certificates                         - словарь со всеми выпускаемыми сертификатами в рамках issuer (vautl role)
ssl.intermediate[“*”].issuers[“*”].certificates[“*”].key-keeper-args    - список аргументов для заказа сертификатов *(мержится с global-args.key-keeper-args 
```

### Настройка kubeconfig
```bash
export CLUSTER_NAME=cluster-1
export CLUSTER_DOMAIN=example.com
export CLUSTER_API_PORT=6443
export CLUSTER_API=https://api.${CLUSTER_NAME}.${CLUSTER_DOMAIN}:${CLUSTER_API_PORT}
export EMAIL="admin.example.com"
export PASSWORD=""
export CA_BUNDLE_PATH=oidc-ca.pem
export OIDC_CLIENT_SECRET=kube-client-secret
export OIDC_CLIENT_ID=kubernetes
export OIDC_ISSUER=https://auth.example.com/auth/realms/master

kubectl config set-cluster ${CLUSTER_NAME} --server=${CLUSTER_API} --insecure-skip-tls-verify

kubectl config set-credentials ${EMAIL} \
  "--exec-api-version=client.authentication.k8s.io/v1beta1" \
  "--exec-arg=oidc-login" \
  "--exec-arg=get-token" \
  "--exec-arg=--oidc-issuer-url=${OIDC_ISSUER}" \
  "--exec-arg=--oidc-client-id=kubernetes" \
  "--exec-arg=--oidc-client-secret=${OIDC_CLIENT_SECRET}" \
  "--exec-arg=--certificate-authority=${CA_BUNDLE_PATH}" \
  "--exec-arg=--skip-open-browser" \
  "--exec-arg=--grant-type=password" \
  "--exec-arg=--username=${EMAIL}" \
  "--exec-arg=--password=${PASSWORD}" \
  "--exec-command=kubectl"

kubectl config set-context ${CLUSTER_NAME} --cluster=${CLUSTER_NAME} --user=${EMAIL}
kubectl config use-context ${CLUSTER_NAME}

```