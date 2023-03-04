locals {
  default_kube_scheduler_flags = {
    leader-elect  = "true"
    secure-port   = "${ local.kubernetes-ports.kube-scheduler-port }"
  }
}