
resource "tls_private_key" "kube_apiserver_sa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
} 

resource "vault_kv_secret_v2" "kube_apiserver_sa" {
  mount = "${vault_mount.kubernetes-secrets.path}"
  name                       = "kube-apiserver-sa"
  cas                        = 1
  delete_all_versions        = true
  data_json = jsonencode(
    {
      private = tls_private_key.kube_apiserver_sa_key.private_key_pem
      public  = tls_private_key.kube_apiserver_sa_key.public_key_pem
    }
  )
}
