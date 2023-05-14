locals {
  default_kube_apiserver_flags = {
    secure-port = "${local.kubernetes-ports.kube-apiserver-port}"
  }
}

data "utils_deep_merge_yaml" "kube_apiserver_flags" {
  input = [
    yamlencode(local.default_kube_apiserver_flags),
    file("${path.module}/default/kube-apiserver.yaml"),
    yamlencode(try(var.extra_args.kube_apiserver_flags, {}))
  ]
}
