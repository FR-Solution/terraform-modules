resource "helm_release" "base-roles" {

  name       = var.release_name
  chart      = "${path.module}/helm/base-roles"
  namespace  = var.namespace
  
  values = [
      try(templatefile("${path.module}/helm/base-roles/values.yaml", {
          extra_values  = local.merge_values
      }))
      
  ]

  timeout   = 6000
  wait      = true
  atomic    = true
}
