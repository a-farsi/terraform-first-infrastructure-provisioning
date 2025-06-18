provider "helm" {
 kubernetes {
    config_path = "~/.kube/config"
 }
}

resource "helm_release" "mysql" {
  name       = "mysql"
  namespace  = "default"
  create_namespace = true
  chart      = "${path.module}/mysql-chart"
  values     = [
    file("${path.module}/mysql-chart/values.yaml")
  ]
}

resource "helm_release" "wordpress" {
  name       = "wordpress"
  chart      = "${path.module}/wordpress-chart"
  namespace  = "default"

  depends_on = [helm_release.mysql] # Pour s'assurer que MySQL est déployé avant

  values = [
    file("${path.module}/wordpress-chart/values.yaml")
  ]
}
