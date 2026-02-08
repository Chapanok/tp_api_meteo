TP Docker

Noé Delquié ESGI 2
Dépôt Git : https://github.com/Chapanok/tp_api_meteo
Branche : main

1) Introduction
Vous aviez demandé de réaliser ce que l’on souhaitait du moment où il y avait : un frontend, un backend et une api.
J’ai donc choisi de reprendre mon projet de flutter et d’y ajouter docker en déployant une architecture 3 tiers avec Docker
Front : html, javascript (sert une page statique et fait le reverse-proxy vers l’API)
Back : Node.js (endpoints /health et /api/cities)
BDD : PostreSQL (avec persistance via volume)

J’ai commencé par envoyer ce prompt à claude code. Je l’ai réalisé avec ChatGPT : Prompt.txt 

J’ai ensuite choisi la solution que je vous ai présenté juste avant


2) Mise en place de le db
Après que j’ai donné le go à claude code, il as tout généré et j’ai pu faire ma bdd. 
J’ai commencé par initialiser le volume,
meteo-pgdata pour conserver les données même après redémarrage

Puis j’ai lancé postgresql avec persistance (volume) + exécution automatique de init.sql au premier démarrage
Screenshot 1-3


3) Lancement du frontend
e frontend est un serveur Nginx : il affiche la page et relaie les appels API vers le backend dans le réseau Docker

4) Création du réseau dédié
J’ai commencé par créer mon réseau
Puis j’ai supprimé le conteneur. Le volume reste le même
Et enfin j’ai relancé la db sur le réseau

Enfin, j’ai relancé le backend, puis le frontend (voir screenshot 6). 

Retour de inspect : Inspect.txt

Screenshot : 5-6

5) Docker Compose 
Avec Docker Compose, les 3 conteneurs démarrent ensemble. J’ai contrôlé les endpoints, ajouté une ville, puis redémarré pour prouver la persistance
Screenshot 9 : ajout d’une ville

