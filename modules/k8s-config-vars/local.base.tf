locals {
    base = {
        cluster_name    = var.extra_args.cluster_name   == null ? "default"           : var.extra_args.cluster_name
        base_domain     = var.extra_args.base_domain    == null ? "example.ru"        : var.extra_args.base_domain
        service_cidr    = var.extra_args.service_cidr   == null ? "172.16.0.0/16"     : var.extra_args.service_cidr
        ssh_username    = var.extra_args.ssh_username   == null ? "dk"                : var.extra_args.ssh_username
        ssh_rsa_path    = var.extra_args.ssh_rsa_path   == null ? "~/.ssh/id_rsa.pub" : var.extra_args.ssh_rsa_path
    }
}
