# kubernetes

```bash
cd base  && terraform init --upgrade && cd -
cd k8s   && terraform init --upgrade && cd -

# Настраивает базовое окружение для VAULT и KEYCLOAK
terraform apply \
  -chdir=base \
  -auto-approve  \
  -state states/base

export CLUSTER_NAME="example" 
export VAULT_ADDRESS="http://vault.ru" 

# Устанавливает кластер
terraform apply \
  -chdir=k8s \
  -var cluster_name="${CLUSTER_NAME}" \
  -var vault_server="${VAULT_ADDRESS}"  \
  -auto-approve  \
  -state states/${CLUSTER_NAME}
```

### INFO
```
Вся информация по сертификатам находится в modules/k8s-config-vars/locals.certs.tf
#! Данный модуль подключается первым и в нем происходит рендер, общего переменного окружения, для остальных модулей.

ssl.global-args.issuers-args                                            - там описаны дефолтные значения для vault roles
ssl.global-args.key-keeper-args                                         - описаны дефолтные значения для заказа сертификата
ssl.intermediate                                                        - словарь со всеми intermediate CA
ssl.intermediate[“*”].issuers                                           - словарь со всеми vault role в рамках CA
ssl.intermediate[“*”].issuers[“*”].backend                              - базовый путь vault role (путь к сейфу pki)
ssl.intermediate[“*”].issuers[“*”].issuer-args                          - разрешенные значения для vault role *(мержится с global-args.issuers-args
ssl.intermediate[“*”].issuers[“*”].certificates                         - словарь со всеми выпускаемыми сертификатами в рамках issuer (vautl role)
ssl.intermediate[“*”].issuers[“*”].certificates[“*”].key-keeper-args    - список аргументов для заказа сертификатов *(мержится с global-args.key-keeper-args 
```

### Установка kubectl login
```bash
# PROJECT -> https://github.com/int128/kubelogin
kubectl krew install oidc-login
```

### Настройка kubeconfig

```bash
export CLUSTER_NAME="cluster-1"
export CLUSTER_DOMAIN="example.com"
export CLUSTER_API_PORT="6443"
export CLUSTER_API="https://api.${CLUSTER_NAME}.${CLUSTER_DOMAIN}:${CLUSTER_API_PORT}"
export EMAIL="admin.example.com"
export PASSWORD=""
export CA_BUNDLE_PATH="oidc-ca.pem"
export OIDC_CLIENT_SECRET="kube-client-secret"
export OIDC_CLIENT_ID="kubernetes-${CLUSTER_NAME}"
export OIDC_ISSUER="https://auth.example.com/auth/realms/master"

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

### Обновление мастеров из нового golden-image
```bash
export CLUSTER_NAME="example" 
export EXTRA_CLUSTER_NAME=$(echo -n ${CLUSTER_NAME} | sha256sum | head -c 8)
export VAULT_ADDRESS="http://vault.ru"

# Перед этим надо переопределить значение image.id
# в module.k8s-yandex-cluster -> master_group.resources_overwrite.master-1.disk.boot.image_id
terraform  apply \
  -chdir=k8s \
  -var cluster_name=${CLUSTER_NAME} \
  -var vault_server="${VAULT_ADDRESS}" \
  -auto-approve \
  -state states/example  \
  -replace=module.k8s-control-plane.yandex_compute_instance.master[\"master-${EXTRA_CLUSTER_NAME}-0\"]
  -refresh=false

terraform apply \
  -chdir=k8s  \
  -var cluster_name="${CLUSTER_NAME}"  \
  -state states/cluster-2 \
  -auto-approve \
  -replace helm_release.mci-debian-11

```

### Установка и настройка кластера
```bash
cd k8s

terraform workspace new cluster-2
terraform workspace select cluster-2

terraform apply -var-file vars/cluster-2.tfvars

terraform destroy -var-file vars/cluster-2.tfvars
```