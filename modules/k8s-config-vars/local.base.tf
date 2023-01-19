locals {
    base = {
        ssh_username    = var.extra_args.ssh_username   == null ? "dk"                : var.extra_args.ssh_username
        ssh_rsa_path    = var.extra_args.ssh_rsa_path   == null ? "~/.ssh/id_rsa.pub" : var.extra_args.ssh_rsa_path
    }
}
