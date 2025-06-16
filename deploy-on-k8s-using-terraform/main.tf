
locals {
 afa-wordpress = {
   App = "afa-wordpress"
   Tier = "frontend"
 }
 afa-mysql = {
   App = "afa-wordpress"
   Tier = "mysql"
 }
}

resource "kubernetes_secret" "afa-mysql-password" {
 metadata {
   name = "afa-mysql-password"
 }
 data = {
   password = "Password123@" # le mot de passe aura pour valeur Password123@
 }
}

resource "kubernetes_secret" "afa-mysql-user" {
 metadata {
   name = "afa-mysql-user"
 }
 data = {
   user = "root" # le user aura pour valeur root
 }
}

resource "kubernetes_deployment" "afa-wordpress" {
 metadata {
   name = "afa-wordpress"
   labels = local.afa-wordpress  # récupère les valeurs déclarées dans la variable afa-wordpress
 }
 spec {
   replicas = 1  # nombre de réplicas
   selector {
     match_labels = local.afa-wordpress
   }
   template {
     metadata {
       labels = local.afa-wordpress
     }
     spec {
       container {
         image = "wordpress:4.8-apache" # image à utiliser pour le déploiement de wordpress
         name  = "afa-wordpress"
         port {
           container_port = 80
         }
         env {  # déclaration des variables d'environnement
           name = "WORDPRESS_DB_HOST"
           value = "mysql-service"
         }
         env {
           name = "WORDPRESS_DB_PASSWORD"
           value_from {
             secret_key_ref {
               name = "afa-mysql-password"
               key = "password"
             }
           }
         }
         env { # déclaration des variables d'environnement
           name = "WORDPRESS_DB_USER"
           value_from {
             secret_key_ref {
               name = "afa-mysql-user"
               key = "user"
             }
           }
         }
       }
     }
   }
 }
}
