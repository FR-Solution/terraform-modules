locals {
  default_kubelet_config_flags = {
    staticPodPath       = "${local.global_path.base_static_pod_path}"
    tlsCertFile         = "${local.ssl.intermediate["kubernetes-ca"].issuers["kubelet-server"].certificates["kubelet-server"].key-keeper-args.host_path}/kubelet-server.pem"
    tlsPrivateKeyFile   = "${local.ssl.intermediate["kubernetes-ca"].issuers["kubelet-server"].certificates["kubelet-server"].key-keeper-args.host_path}/kubelet-server-key.pem"
    healthzPort         = local.kubernetes-ports.kubelet-healthz-port
    authentication = {
        x509 = {
            clientCAFile = "${local.ssl.intermediate["kubernetes-ca"].host_path}/kubernetes-ca.pem"
        }
    }

    clusterDNS = [
        "${local.k8s-addresses.dns_address}"
    ]
  }
}

data "utils_deep_merge_yaml" "kubelet_config_flags" {
  input = [
    yamlencode(local.default_kubelet_config_flags),
    file("${path.module}/default/kubelet.yaml"),
    yamlencode(try(var.extra_args.kubelet_config_flags, {}))
  ]
}
