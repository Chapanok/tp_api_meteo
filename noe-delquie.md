TP flutter Noé Delquié ESGIB
Date : 09/01/2026  
Dépôt Git : [à compléter : lien Github/Gitlab]  
Branche par défaut : main 

Présentation du projet
Application Flutter composée de 2 pages : accueil et météo

1.	Page Accueil
-	Saisie de la ville de résidence de l’user
-	Bouton voir la météo qui amène à la page 2
-	Démonstration d’une API open source (JSONPlaceholder) : test d’appel HTTP et affichage d’un statut (loading/erreur/succès).
Cette partie a été ajoutée pour rajouter du contenu à la page d’accueil qui était vide 

2.	Page Météo
-	Recherche météo via l’api openweathermap
-	 Le champ ville est pré-rempli avec la ville saisie sur la page d’accueil (transfert de données via Provider)
-	Affichage des données météo principales : température, ressenti, humidité, vent, description

APIs utilisées
- OpenWeatherMap : récupération de la météo à partir d’un nom de ville
- JSONPlaceholder : endpoint GET /posts pour démonstration d’appel HTTP


Solutions techniques choisies
-	go_router : navigation entre les pages
-	provider + ChangeNotifier : partage d’état entre pages (ville enregistrée + états loading/erreur/données)
-	http : appels réseau
-	Widgets natifs Material (Column, Row, Padding, Card, Center, ListView, etc.)


État d’avancement
-	Projet clonable / installable / exécutable en environnement de développement
-	2 pages + router fonctionnel
-	Transfert de données (ville saisie sur Accueil -> pré-remplissage sur Météo) via Provider
-	Fonctionnalités opérationnelles (appel OpenWeatherMap + transfert de données)



Lien du dépôt

