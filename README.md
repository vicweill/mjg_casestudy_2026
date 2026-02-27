Bienvenue sur mon étude de cas pour le rôle de Data Analyst chez My Job Glasses !

# Objectif

Ce test a pour but d’évaluer ma capacité à :
- Modéliser et analyser des données avec dbt
- Ecrire du SQL robuste et lisible
- Détecter et traiter des problèmes de qualité des données
- Produire des insights business et des dashboards clairs

Les données disponibles représentent le marché principal de My Job Glasses, où des étudiants entrant en contact avec des professionnels pour discuter de leur carrière. Elles sont composées de 5 tables : schools, users, professional_profiles, conversations, appointments.


# Lancer le projet

## 1. Installer les librairies nécessaires
    pip install -r requirements.txt

## 2. Lancer dbt
Exécuter les commandes `dbt seed` puis `dbt run`


## 3. Visualisation avec Metabase
Pour la partie visualisation, j'ai utilisé Metabase pour être au plus proche de la stack utilisée chez My Job Glasses.

- Prérequis : avoir installé et lancé Docker
    
- Construction de l'image :

  _Conseil : faire ces étapes dans un dossier séparé_

        git clone https://github.com/motherduckdb/metabase_duckdb_driver.git
        cd metabase_duckdb_driver
        docker build -t metabase_duckdb .

- Lancement : 

  _Se replacer dans le dossier dbt, au même endroit que le fichier database.duckdb_

        docker run -d -p 3000:3000 \
        --name metabase_mjg \
        -v "$(pwd)/database.duckdb:/home/metabase/repository/database.duckdb" \
        metabase_duckdb

- Configuration Metabase :

  Une fois l'initialisation finie (cette étape peut prendre quelques minutes) vous aurez accès à Metabase sur l'adresse http://localhost:3000
    Vous devrez ensuite configurer votre base DuckDB avec les informations suivantes :

    |   Paramètre               |   Valeur  |
    |   ----------              |   :----------:    |
    |   Type de base de données |	DuckDB  |
    |   Nom d'affichage         |	_au choix_  |
    |   Path                    |	/home/metabase/repository/database.duckdb   |
    |   Détails additionnels    |	Cocher "Read-only"  |


# Choix réalisés

## dbt
- **Base de données**

J'ai choisi d'utiliser **DuckDB** par soucis de rapidité et de simplicité. Ca m'a permis de créer une base de données en stockant simplement les CSV que j'avais reçus dans des fichiers seed.

- **Modélisation**
    - **Staging** - J'ai utilisé cette étape pour renommer des colonnes et corriger quelques champs textuels en lowercase pour garantir l'uniformité des valeurs.
    - **Intermediate** - J'ai proposé 2 vues pouvant servir de raccourci pour des jointures de futures requêtes, afin d'éviter des répétitions.
    - **Mart** - J'ai représenté les 3 tables demandées dans l'énoncé : monthly_funnel, professionals_usage et students_usage
    - **Tests** - J'ai mis en place 2 types de tests : 

      Dans le fichier schema.yml - pour m'assurer que chaque ligne ait un identifiant unique et non nul. Cela m'a permis de voir qu'il y avait une ligne dupliquée dans la table conversations (id=11) puis de la nettoyer manuellement en supprimant ce doublon. En ajoutant des dépendances à dbt, on pourrait également vérifier que la table n'est pas vide.

      Dans un fichier de test - pour vérifier l'unicité d'un profil professionnel. On ne veut pas d'un professionnel sans descriptif de son emploi, et un professionnel ne peut avoir qu'un seul emploi.

## Metabase

J'ai connecté Metabase aux données créées sur dbt afin d'être au plus proche de la stack de My Job Glasses. L'image Docker utilisée pour lier Metabase à DuckDB n'est pas officielle et sera susceptible d'évoluer.

Présentation des grands groupes d'analyses réalisées dans ce dashboard :

1. **Utilisateurs** : suivre et comprendre l'attractivité et les profils présents sur la plateforme My Job Glasses afin d'orienter les recherches de professionnels et étudiants.

   Pour aller plus loin : nous pourrions filtrer plus précisément dans le temps ces premiers graphiques, mais ca ne faisait pas sens d'ajouter ce type de filtre à un dashboard général.
   
3. **Utilisation de My Job Glasses** : suivi des communications entre professionnels et étudiants dans le temps, et de la manière dont ils se servent de la plateforme.

   Pour aller plus loin : avec plus de temps, nous aurions plus préciser le taux de conversion vers des rendez-vous pour mieux comprendre les utilisations en fonction des profils. Nous pourrions également suivre les utilisateurs dans le temps pour voir combien de temps les utilisateurs restent sur la plateforme. Nous aurions également pu ajouter des filtres dynamiques en fonction des types de profil par exemple pour établir des liens.

4. **Suivi précis d'un professionnel** : en filtrant sur un professionnel en particulier, nous pouvons récupérer les informations principales le concernant.


### Screenshots des pages Metabase

![Page 1](metabase_pages/page1.png "Première page du dashboard")

![Page 2](metabase_pages/page2.png "Première page du dashboard")

## Utilisation d'IA
J'ai utilisé Gemini lorsque j'ai rencontré quelques problèmes/blocages de la configuration de DBT ou de Metabase avec DuckDB. Je n'avais jamais utilisé cette base de données auparavant. Le reste du travail de modélisation, requête et visualisation a été fait par mes soins.
