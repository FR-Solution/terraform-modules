
resource "vault_pki_secret_backend_cert" "terrafor-kubeconfig" {
  depends_on = [vault_pki_secret_backend_role.kubernetes-role]

  backend = local.ssl.intermediate.kubernetes-ca.path
  name = "kube-apiserver-kubelet-client"

  common_name = "custom:terrafor-kubeconfig"
}


locals {
  api_address = tolist(tolist(yandex_lb_network_load_balancer.api-internal.listener)[0].external_address_spec)[0].address
}

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
            "curl --retry 99999 --retry-max-time 60 --retry-delay 1 --max-time 2 ${format("https://%s:6443", local.kube_apiserver_lb_fqdn)} -v"
        ]
    }
}
