locals {

    charlotte_payload  = [
        # { 
        #     # Уникальное имя Security Group (обязательное поле)
        #     name = "example"
        #     # Список подсетей, которые присутствуют в Security Group (необязательное поле)
        #     # Если список пустой или не указан вовсе, SG не будет создана (требуется создать ее отдельно вместе с нетворками)
        #     # Обычно это требуется если сети не определены статикой а будут созданы позже.
        #     # ERROR:> The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, 
        #     # and so Terraform cannot determine the full set of keys │ that will identify the instances of this resource.
        #     cidrs = [
        #         "193.32.219.121/32",
        #     ]
        #     # Список правил для SG (необязательное поле)
        #     rules = [
        #         # Массив всегда имеет ключ sg_to, он не должен дублироваться, 
        #         # все правила до одной SG прописываем в рамках одного массива.
        #         {
        #             # Уникальное имя Security Group (обязательное поле)
        #             # Название SG куда (ДО) открываем доступ
        #             sg_to  = "example"
        #             # Список портов ОТ -> ДО | Протокол
        #             access = [
        #                 {
        #                     # Короткое описание для чего данный доступ
        #                     description = "access from example to example"
        #                     protocol    = "tcp"
        #                     # Открываем доступ ОТ портов
        #                     ports_from    = [
        #                         8000,
        #                     ]
        #                     # Открываем доступ ДО портов
        #                     ports_to    = [
        #                         80,
        #                         443,
        #                     ]
        #                 }
        #             ]
        #         },
        #     ]
        # },
        {
            name = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
            rules = [
                {
                    sg_to  = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}"
                            protocol    = "tcp"
                            ports_to    = [
                                10250, # :::10250   component: kubelet           purpose: server-port
                                6443,  # :::6443    component: kube-apiserver    purpose: server-port
                                2379,  # :::2379    component: etcd              purpose: server-port
                                2380,  # :::2380    component: etcd              purpose: peer-port
                                2381,  # :::2381    component: etcd              purpose: metrics-port
                                2382,  # :::2382    component: etcd              purpose: server-port-target-lb
                            ]
                        },
                    ]
                },
                {
                    sg_to  = "infra/hbf-server"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to hbf-server"
                            protocol    = "tcp"
                            ports_to    = [
                                9000,   # TO HBF-SERVER
                                9200,   # TO VAULT
                                443,    # TO OIDP
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "infra/dns"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to infra/dns"
                            protocol    = "udp"
                            ports_to    = [
                                53, # TO DNS-SERVERS
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/dl.k8s.io"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/dl.k8s.io"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO REGISTRY BIN
                            ]
                        },
                        # {
                        #     description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/dl.k8s.io"
                        #     protocol    = "udp"
                        #     ports_to    = [
                        #         80,    # TO REGISTRY BIN
                        #     ]
                        # }
                    ]
                },
                {
                    sg_to  = "world/k8s.gcr.io"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/k8s.gcr.io"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO REGISTRY DOCKER
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/storage.googleapis.com"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/storage.googleapis.com"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO REGISTRY DOCKER
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/github.com"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/github.com"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO GITHUB REPOSITORY
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "world/objects.githubusercontent.com"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to world/objects.githubusercontent.com"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO GITHUB REPOSITORY
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "yandex/iam"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to yandex/iam"
                            protocol    = "tcp"
                            ports_to    = [
                                80,    # TO REGISTRY BIN
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "yandex/api"
                    access = [
                        {
                            description = "access from kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} to yandex/api"
                            protocol    = "tcp"
                            ports_to    = [
                                443,    # TO API
                            ]
                        }
                    ]
                },
            ]
        },
        {
            name = "infra/hbf-server"
            cidrs = [
                "193.32.219.99/32",
            ]
            rules = []
        },
        {
            name = "infra/dns"
            cidrs = [
                "10.0.0.2/32",
            ]
            rules = []
        },
        {
            name = "world/dl.k8s.io" # Хранилище бинарей
            cidrs = [
                "34.107.204.206/32",
            ]
            rules = []
        },
        {
            name = "world/storage.googleapis.com" # Хранилище бинарей
            cidrs = [
                "173.194.222.128/32",
                "173.194.221.128/32",
                "173.194.220.128/32",
                "173.194.73.128/32",
                "64.233.161.128/32",
                "64.233.162.128/32",
                "64.233.164.128/32",
                "74.125.205.128/32",
            ]
            rules = []
        },
        {
            name = "world/k8s.gcr.io" # Хранилище бинарей
            cidrs = [
                "142.250.150.82/32",
                "209.85.233.82/32",
                "64.233.162.82/32",
                "142.251.1.82/32",
                "173.194.222.82/32",
                "64.233.161.82/32",
                "64.233.165.82/32",
                "173.194.73.82/32",
                "64.233.164.82/32"
            ]
            rules = []
        },
        {
            name = "world/github.com"
            cidrs = [
                "140.82.121.3/32",
                "140.82.121.4/32",
            ]
            rules = []
        },
        {
            name = "world/objects.githubusercontent.com"
            cidrs = [
                "185.199.109.133/32",
                "185.199.108.133/32",
                "185.199.111.133/32",
                "185.199.110.133/32",
            ]
            rules = []
        },
        {
            name = "yandex/iam"
            cidrs = [
                "169.254.169.254/32",
            ]
            rules = []
        },
        {
            name = "yandex/api"
            cidrs = [
                "217.28.237.103/32",
                "213.180.204.240/32",
                "213.180.193.8/32",
                "213.180.193.243/32",
                "84.201.181.26/32",
                "84.201.181.184/32",
                "84.201.168.69/32",
                "84.201.168.170/32",
                "84.201.151.137/32",
                "84.201.148.148/32",
                "84.201.144.177/32",
                "51.250.33.235/32",
            ]
            rules = []
        },
        {
            name = "world"
            cidrs = [
                "176.0.0.0/8",
                "198.0.0.0/8"
            ]
            rules = [
                {
                    sg_to  = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
                    access = [
                        {
                            description = "access from world to kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name} by ssh"
                            protocol    = "tcp"
                            ports_to    = [
                                22,
                                6443,
                            ]
                        },
                    ]
                },
            ]
        }
    ]
}
