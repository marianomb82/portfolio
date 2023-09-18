# Data para acceder a la información del usuario de terraform
data "google_client_openid_userinfo" "terraform_user" {}

# Permisos para poder crear y desplegar recursos en el cluster.
resource "kubernetes_cluster_role_binding" "user" {
  metadata {
    name = "zasema-paradigma-terraform@zasema-paradigma.iam.gserviceaccount.com"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "zasema-paradigma-terraform@zasema-paradigma.iam.gserviceaccount.com"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}