
resource "null_resource" "cluster" {
    for_each    = local.master_instance_list_map

    triggers = {
        cluster_instance_ids = join(",", yandex_compute_instance.master[*][each.key].id)
    }

    connection {
        host        = element(yandex_compute_instance.master[*][each.key].network_interface.0.nat_ip_address, 0)
        user        = "dkot"
        type        = "ssh"
        private_key = file("/home/dk/.ssh/id_rsa")
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
