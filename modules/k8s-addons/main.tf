module "base-roles" {
    source = "../helm-base-roles"

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.cilium, {})
}

module "cilium" {
    count = try(var.extra_values.addons.cilium.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-cilium"
    depends_on = [
        module.yandex-cloud-controller,
    ]
    chart_version       = "1.12.6"

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.cilium, {})
}

module "yandex-cloud-controller" {
    count = try(var.extra_values.addons.yandex-cloud-controller.enabled, false) == true ? 1 : 0

    source = "../helm-yandex-cloud-controller"

    chart_version = "0.0.7"

    yandex_default_vpc_name         = var.k8s_global_vars.master_vars.master_group.vpc_name
    yandex_default_route_table_name = var.k8s_global_vars.master_vars.master_group.route_table_name
    namespace                       = "kube-fraima-yandex-cloud-controller"

    global_vars = var.global_vars

    extra_values = try(var.extra_values.addons.yandex-cloud-controller, {})
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
    extra_values = try(var.extra_values.addons.yandex-csi-controller, {})
}

module "coredns" {
    count = try(var.extra_values.addons.coredns.enabled, false) == true ? 1 : 0

    source = "../helm-coredns"
    depends_on = [
        module.cilium,
    ]
    chart_version       = "1.19.4"

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.coredns, {})
}

module "gatekeeper" {
    count = try(var.extra_values.addons.gatekeeper.enabled, false) == true ? 1 : 0

    source = "../helm-gatekeeper"
    depends_on = [
        module.coredns,
    ]

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.gatekeeper, {})
}

module "certmanager" {
    count = try(var.extra_values.addons.certmanager.enabled, false) == true ? 1 : 0

    source = "../helm-certmanager"
    depends_on = [
        module.gatekeeper,
    ]

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.certmanager, {})
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
    extra_values        = try(var.extra_values.addons.machine-controller-manager, {})
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
    extra_values        = try(var.extra_values.addons.compute-instance, {})
}

module "victoria-metrics-stack-operator" {
    source = "../helm-victoria-metrics-stack-operator"

    count = try(var.extra_values.addons.victoria-metrics-stack-operator.enabled, false) == true ? 1 : 0

    depends_on = [
        module.coredns,
    ]

    global_vars         = var.global_vars
    extra_values        = try(var.extra_values.addons.victoria-metrics-stack-operator, {})
}
