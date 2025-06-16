provider "kubernetes" {
  config_path    = "~/.kube/config" # chemin vers le fichier de configuration de kubernetes
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.9.0"
    }
  }
}
