# 🚀 Projet Infrastructure as Code - Kapsule Korp

![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white) ![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white) ![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white) ![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)

## 📋 Contexte du Projet

La startup **Kapsule Korp** doit moderniser son infrastructure. Face aux limites des déploiements manuels, l'objectif de ce projet est d'implémenter une approche **Infrastructure as Code (IaC)**.

Le projet consiste à automatiser le déploiement d'une pile applicative **LEMP** (Linux, Nginx, MySQL, PHP) complète et sécurisée pour Kapsule Korp sur deux environnements distincts : **Staging** (Test) et **Production**.

---

## 🏗️ Architecture Technique

Le projet déploie une architecture composée de machines virtuelles en **Ubuntu 22.04 LTS**.

### 1. Les Environnements
L'infrastructure est divisée pour garantir la fiabilité des mises en production :
* **Staging :** Environnement de recette pour valider les configurations (1 serveur Web + 1 DB).
* **Production :** Environnement final stable (1 serveur Web + 1 DB).

### 2. La Pile Technologique (LEMP)
* **Serveur Web :** Nginx.
* **Langage :** PHP 8.1 avec PHP-FPM.
* **Base de Données :** MySQL 8.0 (Sécurisé et accessible uniquement par le web).
* **Sécurité :** Gestion des secrets (mots de passe) via **Ansible Vault**.

---

## 📂 Structure du Projet

```
PROJET-KAPSULEKORP-IAC/
├── group_vars/                 # Variables spécifiques aux environnements
│   ├── staging/
│   │   └── db_vault.yml        # Secrets chiffrés pour le Staging
│   ├── production/
│   │   └── db_vault.yml        # Secrets chiffrés pour la Production
    ├── host_vars/
    |   └── db-prod/
    |       └── secrets.yml     # Secrets chiffrés pour la DB de Production
    |   └── db-staging/
    |       └── secrets.yml     # Secrets chiffrés pour la DB de Staging
    |   └── web-prod/
    |       └── secrets.yml     # Secrets chiffrés pour le serveur web de production
    |   └── web-staging/
    |       └── secrets.yml     # Secrets chiffrés pour le serveur web de staging
├── roles/                      # Rôles modulaires
│   ├── nginx/                  # Installation, Vhost dynamique, Page de test
│   ├── mysql/                  # Installation DB, User dédié, Bind-address
│   └── php/                    # Installation PHP 8.1, Config php.ini
├── inventory.ini               # Inventaire des serveurs (IPs et Groupes)
├── script-kk-base.sh           # Script de préparation d'une machine de contrôle
├── site.yml                    # Playbook principal
└── README.md                   # Documentation
```

### Prérequis et Installation
#### Prérequis sur la machine de contrôle 

**Ansible** (version 2.9 ou supérieure).

**Accès SSH** configuré vers les machines cibles (clés SSH déployées).

**Python 3** installé sur les machines cibles.

Le mot de passe du coffre-fort (Vault Password).

#### 1. Installation
Cloner le dépôt sur votre machine locale :

```code
git clone <url-du-depot-git>
cd projet-kapsulekorp-iac
```

#### 2. Configuration de l'Inventaire 

Mettez à jour le fichier inventory.ini avec les IPs de vos machines virtuelles :

```
[staging]
srv-staging-web ansible_host=0.0.0.0 ansible_user=votre_user
srv-staging-db  ansible_host=0.0.0.0 ansible_user=votre_user

[production]
srv-prod-web    ansible_host=0.0.0.0 ansible_user=votre_user
srv-prod-db     ansible_host=0.0.0.0 ansible_user=votre_user
```

### 3. Gestion des Secrets (Vault) 

Les mots de passe des bases de données sont chiffrés. Pour les modifier :

Bash
```code
ansible-vault edit group_vars/staging/db_vault.yml
```

### 🚀 Déploiement
Le déploiement est entièrement automatisé. Une seule commande suffit pour provisionner et configurer toute l'infrastructure (Staging + Production).

Exécutez la commande suivante:
```bash
ansible-playbook -i inventory.ini site.yml --ask-vault-pass -K
```
Détails des options :
*-i inventory.ini* : Cible le fichier d'inventaire.

*--ask-vault-pass* : Invite à saisir le mot de passe pour déchiffrer les variables sensibles (DB passwords).

*-K* (ou --ask-become-pass) : Invite à saisir le mot de passe sudo pour l'élévation de privilèges sur les serveurs.

### ✅ Vérification et Tests
Une page de statut dynamique est déployée automatiquement pour vérifier le bon fonctionnement de la pile.

Accéder au site de Staging :
```code
URL : http://<IP-STAGING-WEB>/index.php
```

Résultat attendu : Affiche "Environnement : Staging" et "Connexion DB : OK".

Accéder au site de Production :

```code
URL : http://<IP-PROD-WEB>/index.php
```

Résultat attendu : Affiche **"Environnement"** : **"Production"** et **"Connexion DB : OK"**.

Points forts de la solution :
* **Idempotence** : Le playbook peut être relancé plusieurs fois sans casser l'existant.

* **Ségrégation** : Les environnements ne partagent pas les mêmes bases de données.

* **Sécurité** : Aucun mot de passe n'apparaît en clair dans le code.