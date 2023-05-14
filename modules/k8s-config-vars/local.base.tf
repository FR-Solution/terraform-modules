locals {
    base = {
        ssh_username    = try(var.extra_args.ssh_username, null)   == null ? "dk"                : var.extra_args.ssh_username
        ssh_rsa_path    = try(var.extra_args.ssh_rsa_path, null)   == null ? "~/.ssh/id_rsa.pub" : var.extra_args.ssh_rsa_path
    }
}
