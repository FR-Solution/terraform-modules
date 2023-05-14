locals {
  k8s_provider = {
    service_account_name  = try(var.extra_args.serviceaccount_k8s_controllers_name, "k8s-controllers")
    namespace             = try(var.extra_args.namespace,                           "kube-fraime-controllers")
  }
}
