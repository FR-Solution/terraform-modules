
resource "null_resource" "cluster" {
    for_each    = var.cluster_instances

    triggers = {
        cluster_instance_ids = join(",", keys(var.cluster_instances))
    }

    connection {
        host        = each.value
        user        = var.k8s_global_vars.base.ssh_username
        type        = "ssh"
        private_key = file(split(".pub", var.k8s_global_vars.base.ssh_rsa_path)[0])
        agent = "false"
    }
    # TODO поправить команду так, что бы не падала сборка
    provisioner "remote-exec" {
        inline = [
            "until cloud-init status | grep -i done; do sleep 1s; done",
            "sudo kubectl --request-timeout=5m cluster-info  --kubeconfig=/etc/kubernetes/admin.conf"
        ]
    }
}
