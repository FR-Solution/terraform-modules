variable "vault_server" {
  type = string
  default = ""
}


variable "vault_config" {
  type = object({
    caBundle        = string
    tlsInsecure     = bool
  })
  default = {
    caBundle    = ""
    tlsInsecure = true
  }
}


locals {
  base_local_path_certs   = "/etc/kubernetes/pki"
  base_local_path_vault   = "/var/lib/key-keeper/vault"
  base_vault_path         = "clusters/${var.cluster_name}"
  base_vault_path_kv      = "${local.base_vault_path}/kv"
  base_vault_path_approle = "${local.base_vault_path}/approle"
  root_vault_path_pki     = "pki-root"
  
  ssl = {
    global-args = {
      issuer-args = {
        allow_any_name                      = false
        allow_bare_domains                  = true
        allow_glob_domains                  = true
        allow_subdomains                    = false
        allowed_domains_template            = true
        basic_constraints_valid_for_non_ca  = false
        code_signing_flag                   = false
        email_protection_flag               = false
        enforce_hostnames                   = false
        generate_lease                      = false
        allow_ip_sans                       = false
        allow_localhost                     = false
        client_flag                         = false
        server_flag                         = false
        key_bits                            = 4096
        key_type                            = "rsa"
        key_usage                           = []
        organization                        = []
        country                             = []
        locality                            = []
        ou                                  = []
        postal_code                         = []
        province                            = []
        street_address                      = []
        allowed_domains                     = []
        allowed_other_sans                  = []
        allowed_serial_numbers              = []
        allowed_uri_sans                    = []
        ext_key_usage                       = []
        no_store                            = false
        require_cn                          = false
        ttl                                 = 31540000
        use_csr_common_name                 = true
        
      }
      key-keeper-args = {
        spec = {
          subject = {
            commonName          = ""
            country             = ""
            localite            = ""
            organization        = ""
            organizationalUnit  = ""
            province            = ""
            postalCode          = ""
            streetAddress       = ""
            serialNumber        = ""
          }
          privateKey = {
            algorithm = "RSA"
            encoding  = "PKCS1"
            size      = 4096
          }
          ttl         = "10m"
          ipAddresses = {}
          hostnames   = []
          usages      = []
        }
        renewBefore   = "7m"
        trigger       = []
        withUpdate    = true

      }
    }
    intermediate = {
      kubernetes-ca = {
        labels = {
          instance-master = true
          instance-worker = true
        }
        common_name   = "Kubernetes Intermediate CA",
        description   = "Kubernetes Intermediate CA"
        path          = "clusters/${var.cluster_name}/pki/kubernetes"
        root_path     = "clusters/${var.cluster_name}/pki/root"
        host_path     = "${local.base_local_path_certs}/ca"
        type          = "internal"
        organization  = "Kubernetes"
        exportedKey  = false
        generate     = false
        default_lease_ttl_seconds = 321408000
        max_lease_ttl_seconds     = 321408000
        issuers = {
          bootstrappers-client = {
            labels = {
              instance-worker = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ClientAuth"]
              allowed_domains = [
                "custom:bootstrappers:*"
                
              ]
              organization = [
                "system:bootstrappers"
              ]
              client_flag = true
            }
            certificates = {
              bootstrappers-client = {
                labels = {
                  instance-worker = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonNamePrefix = "custom:bootstrappers"
                      organization = [
                        "system:bootstrappers"
                      ]
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.base_local_path_certs}/certs/kubelet"
                }
              }
            }
          },
          kube-controller-manager-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ClientAuth"]
              allowed_domains = [
                "system:kube-controller-manager"
              ]
              client_flag = true
            }
            certificates = {
              kube-controller-manager-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:kube-controller-manager"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path     = "${local.base_local_path_certs}/certs/kube-controller-manager"
                }
              }

            }
          },
          kube-controller-manager-server = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ServerAuth"]
              allowed_domains = [
                "localhost",
                "kube-controller-manager.default",
                "kube-controller-manager.default.svc",
                "kube-controller-manager.default.svc.cluster",
                "kube-controller-manager.default.svc.cluster.local",
                "custom:kube-controller-manager"
              ]
              server_flag     = true
              allow_ip_sans   = true
              allow_localhost = true
            }
            certificates = {
              kube-controller-manager-server = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-controller-manager"
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "kube-controller-manager.default",
                      "kube-controller-manager.default.svc",
                      "kube-controller-manager.default.svc.cluster",
                      "kube-controller-manager.default.svc.cluster.local",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.base_local_path_certs}/certs/kube-controller-manager"
                }
              }

            }
          },
          kube-apiserver-kubelet-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ClientAuth"]
              allowed_domains = [
                "custom:kube-apiserver-kubelet-client",
                "custom:terraform-kubeconfig",
              ]
              organization = ["system:masters"]
              client_flag  = true
            }
            certificates = {
              kube-apiserver-kubelet-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-apiserver-kubelet-client",
                      organizationalUnit = [
                        "system:masters"
                        ]
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
          kube-apiserver = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ServerAuth"]
              allowed_domains = [
                "localhost",
                "kubernetes",
                "kubernetes.default",
                "kubernetes.default.svc",
                "kubernetes.default.svc.cluster",
                "kubernetes.default.svc.cluster.local",
                "custom:kube-apiserver",
                local.kube_apiserver_lb_fqdn,
                local.kube_apiserver_lb_fqdn_local
              ]
              server_flag     = true
              allow_ip_sans   = true
              allow_localhost = true
            }
            certificates = {
              kube-apiserver = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-apiserver"
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "kubernetes",
                      "kubernetes.default",
                      "kubernetes.default.svc",
                      "kubernetes.default.svc.cluster",
                      "kubernetes.default.svc.cluster.local",
                      local.kube_apiserver_lb_fqdn,
                      local.kube_apiserver_lb_fqdn_local
                    ]
                    ipAddresses = {
                      static = [
                        local.local_api_address
                      ]
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = [
                        "${local.kube_apiserver_lb_fqdn}"
                      ]
                    }
                  }
                  host_path = "${local.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
          kube-scheduler-server = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ServerAuth"]
              allowed_domains = [
                "localhost",
                "kube-scheduler.default",
                "kube-scheduler.default.svc",
                "kube-scheduler.default.svc.cluster",
                "kube-scheduler.default.svc.cluster.local",
                "custom:kube-scheduler"
              ]
              server_flag     = true
              allow_ip_sans   = true
              allow_localhost = true
            }
            certificates = {
              kube-scheduler-server = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-scheduler"
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "kube-scheduler.default",
                      "kube-scheduler.default.svc",
                      "kube-scheduler.default.svc.cluster",
                      "kube-scheduler.default.svc.cluster.local",
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                    }
                  }
                  host_path = "${local.base_local_path_certs}/certs/kube-scheduler"
                }
              }
            }
          },
          kube-scheduler-client = {
            labels = {
              instance-master = true
            }
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ClientAuth"]
              allowed_domains = [
                "system:kube-scheduler"
              ]
              client_flag = true
            }
            certificates = {
              kube-scheduler-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:kube-scheduler"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.base_local_path_certs}/certs/kube-scheduler"
                }
              }
            }
          },
          kubelet-peer-k8s-certmanager = {
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ServerAuth","ClientAuth"]
              key_bits  = 0
              key_type  = "any"
              allowed_domains = [
                "localhost",
                "*.${var.cluster_name}.${var.base_domain}",
                "system:node:*",
                "worker-*",
                "master-*"
              ]
              organization = [
                "system:nodes",
              ]
              server_flag     = true
              client_flag     = true
              allow_ip_sans   = true
              allow_localhost = true
            }
            certificates = {}
          }
          kubelet-server = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ServerAuth"]
              allowed_domains = [
                "localhost",
                local.wildcard_base_cluster_fqdn,
                "system:node:*",
                "master-*",  # КОСТЫЛЬ
                "worker-*"   # КОСТЫЛЬ
              ]
              organization = [
                "system:nodes",
                "system:authenticated"
              ]
              server_flag     = true
              allow_ip_sans   = true
              allow_localhost = true
            }
            certificates = {
              kubelet-server = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonNamePrefix = "system:node"
                      organizations = [
                        "system:nodes"
                      ]
                    }
                    usages = [
                      "server auth",
                    ]
                    hostnames = [
                      "localhost",
                      "$HOSTNAME"
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = []
                    }
                    # ttl = "200h"
                  }
                  host_path     = "${local.base_local_path_certs}/certs/kubelet"
                  # renewBefore   = "100h"
                }
              }
            }
          }
          kubelet-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/kubernetes"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ClientAuth"]
              allowed_domains = [
                "system:node:*",
              ]
              organization = [
                "system:nodes",
              ]
              client_flag = true
            }
            certificates = {
              kubelet-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonNamePrefix = "system:node"
                      organization = [
                        "system:nodes"
                      ]
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.base_local_path_certs}/certs/kubelet"
                }
              }
            }
          },
        }
      }
      etcd-ca = {
        labels = {
          instance-master = true
        }
        common_name  = "ETCD Intermediate CA",
        description  = "ETCD Intermediate CA"
        path         = "clusters/${var.cluster_name}/pki/etcd"
        root_path    = "clusters/${var.cluster_name}/pki/root"
        host_path    = "${local.base_local_path_certs}/ca"
        type         = "internal"
        organization = "Kubernetes"
        exportedKey  = false
        generate     = false
        default_lease_ttl_seconds = 321408000
        max_lease_ttl_seconds     = 321408000
        issuers = {
          etcd-server = {
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/etcd"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ServerAuth"]
              allowed_domains = [
                "system:etcd-server",
                "localhost",
                "*.${var.cluster_name}.${var.base_domain}",
                "custom:etcd-server"
              ]
              server_flag     = true
              allow_ip_sans   = true
              allow_localhost = true
            }
            certificates = {
            }
          },
          etcd-peer = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/etcd"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ServerAuth", "ClientAuth"]
              allowed_domains = [
                "system:etcd-peer",
                "system:etcd-server",
                "localhost",
                "custom:etcd-peer",
                "custom:etcd-server",
                local.wildcard_base_cluster_fqdn,
                "master-*" # КОСТЫЛЬ
              ]
              client_flag     = true
              server_flag     = true
              allow_ip_sans   = true
              allow_localhost = true
            }
            certificates = {
              etcd-server = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:etcd-server"
                    }
                    usages = [
                      "server auth",
                      "client auth"
                    ]
                    hostnames = [
                      "localhost",
                      "$HOSTNAME"
                      # "${local.etcd_server_lb_fqdn}"
                    ]
                    ipAddresses = {
                      static = [
                        "127.0.1.1"
                      ]
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = []
                    }
                  }
                  host_path = "${local.base_local_path_certs}/certs/etcd"
                }
              }
              etcd-peer = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:etcd-peer"
                    }
                    usages = [
                      "server auth",
                      "client auth"
                    ]
                    hostnames = [
                      "localhost",
                      "$HOSTNAME"
                    ]
                    ipAddresses = {
                      interfaces = [
                        "lo",
                        "eth*"
                      ]
                      dnsLookup = []
                    }
                  }
                  host_path = "${local.base_local_path_certs}/certs/etcd"
                }
              }
            }
          },
          etcd-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/etcd"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ClientAuth"]
              allowed_domains = [
                "system:kube-apiserver-etcd-client",
                "system:etcd-healthcheck-client",
                "custom:etcd-client"
              ]
              client_flag = true
            }
            certificates = {
              kube-apiserver-etcd-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "system:kube-apiserver-etcd-client"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
        }
      }
      front-proxy-ca = {
        labels = {
          instance-master = true
        }
        common_name  = "Front-proxy Intermediate CA",
        description  = "Front-proxy Intermediate CA"
        path         = "clusters/${var.cluster_name}/pki/front-proxy"
        root_path    = "clusters/${var.cluster_name}/pki/root"
        host_path    = "${local.base_local_path_certs}/ca"
        type         = "internal"
        organization = "Kubernetes"
        exportedKey  = false
        generate     = false
        default_lease_ttl_seconds = 321408000
        max_lease_ttl_seconds     = 321408000
        issuers = {
          front-proxy-client = {
            labels = {
              instance-master = true
            }
            issuer-args = {
              backend   = "clusters/${var.cluster_name}/pki/front-proxy"
              key_usage = ["DigitalSignature", "KeyAgreement", "KeyEncipherment", "ClientAuth"]
              allowed_domains = [
                "system:kube-apiserver-front-proxy-client",
                "custom:kube-apiserver-front-proxy-client"
              ]
              client_flag = true
            }
            certificates = {
              front-proxy-client = {
                labels = {
                  instance-master = true
                }
                key-keeper-args = {
                  spec = {
                    subject = {
                      commonName = "custom:kube-apiserver-front-proxy-client"
                    }
                    usages = [
                      "client auth"
                    ]
                  }
                  host_path = "${local.base_local_path_certs}/certs/kube-apiserver"
                }
              }
            }
          },
        }
      }
    }
    root_ca = {
      root = {
        CN          = "root",
        description = "root-ca"
        path        = "clusters/${var.cluster_name}/pki/root"
        root_path   = "${local.root_vault_path_pki}"
        common_name = "Kubernetes Root CA"
        type        = "internal"
        default_lease_ttl_seconds = 321408000
        max_lease_ttl_seconds     = 321408000
      }
    }
    external_intermediate = {
      oidc-ca = {
        labels = {
          instance-master = true
        }
        description   = "OIDC CA"
        path          = "pki-root"
        exportedKey   = false
        generate      = false
        host_path     = "${local.base_local_path_certs}/ca"
      }
    }
  }
  
  secrets = {
    kube-apiserver-sa = {
      labels = {
        instance-master = true
      }
      path = local.base_vault_path_kv
      keys = {
        public = {
          host_path = "${local.base_local_path_certs}/certs/kube-apiserver/kube-apiserver-sa.pub"
        }
        private = {
          host_path = "${local.base_local_path_certs}/certs/kube-apiserver/kube-apiserver-sa.pem"
        }
      }
    }
  }
}

