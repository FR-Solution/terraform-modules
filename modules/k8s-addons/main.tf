module "base-roles" {
    source = "../helm-base-roles"

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.cilium.extra_values, {})
}

module "cilium" {
    count = try(var.extra_values.addons.cilium.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-cilium"
    depends_on = [
        module.yandex-cloud-controller,
    ]
    chart_version       = "1.12.6"

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.cilium.extra_values, {})
}

module "yandex-cloud-controller" {
    count = try(var.extra_values.addons.yandex-cloud-controller.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-cloud-controller"

    chart_version = "0.0.7"

    yandex_default_vpc_name         = var.master_group.vpc_name
    yandex_default_route_table_name = var.master_group.route_table_name
    namespace                       = "kube-fraima-yandex-cloud-controller"

    global_vars = var.global_vars

    extra_values = try(var.extra_values.addons.yandex-cloud-controller.extra_values, {})
}

module "yandex-csi-controller" {
    count = try(var.extra_values.addons.yandex-csi-controller.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-csi-controller"

    depends_on = [
        module.cilium
    ]

    namespace           = "kube-fraima-yandex-csi-controller"

    chart_version       = "0.0.8"
    global_vars         = var.global_vars
    extra_values = try(var.extra_values.addons.yandex-csi-controller.extra_values, {})
}

module "coredns" {
    count = try(var.extra_values.addons.coredns.enabled, false) == true ? 1 : 0

    source = "../helm-coredns"
    depends_on = [
        module.cilium,
    ]
    chart_version       = "1.19.4"

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.coredns.extra_values, {})
}

module "gatekeeper" {
    count = try(var.extra_values.addons.gatekeeper.enabled, false) == true ? 1 : 0

    source = "../helm-gatekeeper"
    depends_on = [
        module.coredns,
    ]

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.gatekeeper.extra_values, {})
}

module "certmanager" {
    count = try(var.extra_values.addons.certmanager.enabled, false) == true ? 1 : 0

    source = "../helm-certmanager"
    depends_on = [
        module.gatekeeper,
    ]

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.certmanager.extra_values, {})
}

module "vault-issuer" {
    count = try(var.extra_values.addons.vault-issuer.enabled, false) == true ? 1 : 0

    source = "../helm-vault-issuer"
    depends_on = [
        module.certmanager,
        module.gatekeeper,
    ]

    global_vars = var.global_vars

}

module "machine-controller-manager" {
    count = try(var.extra_values.addons.machine-controller-manager.enabled, false) == true ? 1 : 0

    source = "../helm-machine-controller-manager"
    depends_on = [
        module.gatekeeper,
    ]

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.machine-controller-manager.extra_values, {})
}

module "compute-instance" {
    source = "../helm-yandex-machine-instance"

    count = try(var.extra_values.addons.compute-instance.enabled, false) == true ? 1 : 0

    depends_on = [
      module.certmanager,
      module.machine-controller-manager
    ]

    global_vars         = var.global_vars
    custom_values       = try(var.extra_values.addons.compute-instance.custom_values, {})
    extra_values        = try(var.extra_values.addons.compute-instance.extra_values, {})
}
