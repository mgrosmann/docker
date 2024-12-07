#pas interessant
''=interessant
() a voir


'Vérifier et recréer les réseaux Docker manquants pour les conteneurs arrêtés.'
'Supprimer tous les conteneurs arrêtés.'
'lors de l'entrée d''un port proposer entrer un aléatoire parmi ceux disponibles'
'proposer d'entrer un mot de passe sécurisé qui sera envoyé dans un password.txt que l'utilisateur' devra supprimer'

'Sauvegarder un conteneur dans une image Docker.
Restaurer un conteneur à partir d''une image Docker.'
'Supprimer un volume Docker spécifique.'
'Sauvegarder les données d’un volume Docker dans une archive compressée.
Restaurer un volume Docker à partir d''une archive compressée.'
'Vérifier et recréer les réseaux Docker manquants pour les conteneurs arrêtés.'
'Exporter les logs d’un conteneur spécifique dans un fichier texte.'
'Supprimer tous les conteneurs arrêtés.'
'Mettre à jour une image Docker et recréer les conteneurs associés.'
'Lister toutes les images Docker avec leur taille et leur utilisation.'
'Afficher les détails d’un conteneur spécifique (inspecter les métadonnées et la configuration).'
'Créer une image Docker personnalisée à partir d’un Dockerfile.'
'Vérifier la consommation d’espace disque totale par Docker (images, conteneurs, volumes).'
'Redémarrer un conteneur spécifique.'
'Copier des fichiers entre un hôte et un conteneur.'
'Automatiser les déploiements avec des pipelines CI/CD pour construire et déployer des images Docker.'
'Auditer la sécurité des conteneurs avec des outils comme Clair ou Trivy.'
'Exposer les ports spécifiques d’un conteneur (mapping de ports).'
(Déployer des applications conteneurisées sur des orchestrateurs comme Kubernetes ou Docker Swarm.)
Supprimer toutes les images non utilisées (dangling images).
(Créer et exécuter un conteneur interactif basé sur une image (par exemple, Ubuntu ou Debian).)
(Rechercher un conteneur spécifique par nom ou par image.)
(Créer un nouveau volume Docker.)
#Lister tous les volumes Docker existants.
#Configurer le redémarrage automatique pour un conteneur (policy: always ou unless-stopped).
#Afficher l’utilisation des ressources (CPU, mémoire, disque) par conteneur avec docker stats.
#Gérer les conteneurs multi-services avec Docker Compose (démarrage/arrêt).
#Tester la connectivité réseau entre deux conteneurs.
#Attribuer un alias réseau à un conteneur pour simplifier les connexions.
#Changer les ressources allouées à un conteneur (mémoire, CPU) sans le recréer.
#Visualiser les logs en temps réel d’un conteneur spécifique.
#Analyser les performances d’un conteneur avec des outils comme cAdvisor.
#Configurer des limites de ressources (CPU, mémoire) pour un conteneur au moment de sa création.
#Gérer les secrets et variables d’environnement pour les conteneurs.
#Lister tous les conteneurs actifs et arrêtés avec leurs détails (ID, noms, images, ports, état).
#Nettoyer les conteneurs, images, volumes et réseaux inutilisés pour libérer de l'espace.




Creation/installation conteneur conteneur:
1) Créer un nouveau conteneur avec l'image HTTPD ou en modifier un existant
2) Installer le conteneur multi-service (MySQL, phpMyAdmin, FTP, APACHE)
7) Créer un nouveau conteneur avec l'image MySQL et phpMyAdmin
8) Installer un conteneur MySQL, HTTPD ou phpMyAdmin  en session interactive ou détaché 


Gestion des conteneurs existants
3) Se connecter à un conteneur
4) Démarrer tous les conteneurs
5) Arrêter tous les conteneurs
6) Installer nano et wget sur un conteneur
9) Vérifier et recréer les réseaux Docker manquants pour les conteneurs arrêtés
10) Supprimer tous les conteneurs arrêtés



Conteneur interactif
Httpd
echo -e "${LIGHT_GREEN}1)${NC} Créer un conteneur interactif Apache HTTPD"
echo -e "${LIGHT_GREEN}2)${NC} Créer un conteneur interactif Apache HTTPD avec volume monté"
Mysql 
echo -e "${LIGHT_GREEN}3)${NC} Créer un conteneur interactif MySQL sans mot de passe"
echo -e "${LIGHT_GREEN}4)${NC} Créer un conteneur interactif MySQL avec mot de passe"
PhpMyadmin
echo -e "${LIGHT_GREEN}5)${NC} Créer un conteneur intéractif PhpMyadmin"
SSH/SFTP
echo -e "${LIGHT_GREEN}11)${NC} Créer un conteneur interactif Ubuntu SSH avec utilisateur et mot de passe"


Conteneur détaché
Httpd
echo -e "${LIGHT_GREEN}6)${NC} Créer un conteneur détaché Apache HTTPD"
echo -e "${LIGHT_GREEN}7)${NC} Créer un conteneur détaché Apache HTTPD avec volume monté"
Mysql 
echo -e "${LIGHT_GREEN}8)${NC} Créer un conteneur détaché MySQL sans mot de passe"
echo -e "${LIGHT_GREEN}9)${NC} Créer un conteneur détaché MySQL avec mot de passe"
PhpMyadmin
echo -e "${LIGHT_GREEN}10)${NC} Créer un conteneur détaché PhpMyadmin"
SSH/SFTP
echo -e "${LIGHT_GREEN}12)${NC} Créer un conteneur détaché Ubuntu SSH avec utilisateur et mot de passe"
