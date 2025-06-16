# Déploiement WordPress et MySQL sur Kubernetes avec Terraform

**Objectif :** Déployer une application WordPress complète avec sa base de données MySQL sur un cluster Kubernetes en utilisant Terraform comme outil d'Infrastructure as Code.

## Étapes de déploiement

### ÉTAPE 1: Préparer les secrets

```
CRÉER secret "mysql-password" 
    - stocker mot_de_passe_db
CRÉER secret "mysql-user"
    - stocker nom_utilisateur_db
```

Création des secrets Kubernetes pour stocker de manière sécurisée les identifiants de connexion à la base de données.

### ÉTAPE 2: Déployer la base de données

```
CRÉER deployment "mysql" 
    - utiliser image mysql:5.6 + exposer port 3306
CRÉER service "mysql-service" 
    - exposer mysql en interne sur port 3306
```

Déploiement du conteneur MySQL avec son service interne pour permettre la communication avec WordPress.

### ÉTAPE 3: Déployer WordPress

```
CRÉER deployment "wordpress"
    - image wordpress:4.8-apache + variables d'environnement DB
CRÉER service "wordpress-service"
    - exposer vers extérieur via NodePort 32000
```

Déploiement de WordPress configuré pour se connecter à MySQL, avec exposition publique via NodePort.

### ÉTAPE 4: Exécution

```
terraform init
terraform plan
terraform apply
```

Application de la configuration Terraform pour créer l'infrastructure sur le cluster Kubernetes.
Résultat : WordPress accessible via http://NODE_IP:32000 avec base de données MySQL fonctionnelle.


## Pseudo-code du déploiement


```
ÉTAPE 1: Préparer les secrets
  CRÉER secret "mysql-password" 
    ==> stocker mot_de_passe_db
  CRÉER secret "mysql-user"
    ==> stocker nom_utilisateur_db

ÉTAPE 2: Déployer la base de données
  CRÉER deployment "mysql"
    ==> utiliser image mysql:5.6
    ==> exposer port 3306
    ==> récupérer credentials depuis secrets
    ==> appliquer labels pour identification
  
  CRÉER service "mysql-service"
    ==> exposer mysql en interne sur port 3306
    ==> permettre communication inter-pods

ÉTAPE 3: Déployer WordPress
  CRÉER deployment "wordpress" 
    ==> utiliser image wordpress:4.8-apache
    ==> exposer port 80
    ==> configurer variables d'environnement:
      * DB_HOST = "mysql-service"
      * DB_USER = récupérer depuis secret
      * DB_PASSWORD = récupérer depuis secret
  
  CRÉER service "wordpress-service"
    ==> exposer wordpress vers extérieur
    ==> NodePort 32000 ==> port 80 du container

ÉTAPE 4: Exécution
  terraform init
  terraform plan
  terraform apply
  
```