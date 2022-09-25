# kubernetes

```bash
cd vault && terraform init && cd -
cd k8s   && terraform init && cd -

terraform -chdir=k8s apply -var cluster_name="cluster-1" -var vault_server="http://example.com" -auto-approve
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