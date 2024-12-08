<?php
// action.php

// Fonction pour exécuter les actions de création et d'installation des conteneurs
function executeCreationInstallationAction($choix, $container_name, $image_id) {
    switch ($choix) {
        case 1:
            return shell_exec("docker run -d --name $container_name httpd");
        case 2:
            return shell_exec("docker-compose up -d");
        case 3:
            return shell_exec("docker run -d --name $container_name -e MYSQL_ROOT_PASSWORD=root mysql:latest");
        case 4:
            return shell_exec("docker run -d -it --name $container_name ubuntu bash");
        case 5:
            return shell_exec("docker rm $container_name");
        case 6:
            return shell_exec("docker rmi $image_id");
        default:
            return "Choix non valide.";
    }
}

// Fonction pour exécuter les actions de gestion des conteneurs
function executeGestionConteneursAction($choix, $container_name) {
    switch ($choix) {
        case 1:
            return shell_exec("docker exec -it $container_name bash");
        case 2:
            return shell_exec("docker start $(docker ps -a -q)");
        case 3:
            return shell_exec("docker stop $(docker ps -q)");
        case 4:
            return shell_exec("docker exec -it $container_name apt-get install nano wget");
        case 5:
            return shell_exec("docker network prune -f");
        case 6:
            return shell_exec("docker rm $(docker ps -a -q -f status=exited)");
        case 7:
            return shell_exec("docker-compose up --force-recreate -d");
        default:
            return "Choix non valide.";
    }
}

// Fonction pour exécuter les actions d'outils de gestion Docker
function executeOutilsGestionAction($choix, $container_name = null) {
    switch ($choix) {
        case 1:
            return shell_exec("docker images");
        case 2:
            return shell_exec("docker ps -a");
        case 3:
            return getDockerLogs($container_name);
        case 4:
            return shell_exec("docker stats");
        case 5:
            return shell_exec("docker network ls");
        case 6:
            return shell_exec("docker volume ls");
        case 7:
            return handleBackupRestoreContainer($container_name);
        default:
            return "Choix non valide.";
    }
}

// Fonction pour afficher les logs d'un conteneur
function getDockerLogs($container_name) {
    // Si le nom ou l'ID du conteneur est vide, retourner un message d'erreur
    if (empty($container_name)) {
        return "Veuillez fournir le nom ou l'ID du conteneur.";
    }
    
    // Vérifier si le conteneur existe
    $check_container_command = "docker ps -a -q -f name=$container_name";
    $container_exists = shell_exec($check_container_command);

    if (empty($container_exists)) {
        return "Conteneur introuvable. Veuillez vérifier le nom ou l'ID.";
    }
    
    // Exécuter la commande pour obtenir les logs du conteneur
    $logs_command = "docker logs $container_name";
    $logs_result = shell_exec($logs_command);

    if ($logs_result === null) {
        return "Erreur lors de l'affichage des logs du conteneur.";
    }

    return $logs_result;
}

// Fonction pour gérer la sauvegarde et la restauration d'un conteneur
function handleBackupRestoreContainer($container_name) {
    $backup_image = "backup_$container_name";
    $backup_command = "docker commit $container_name $backup_image";
    $backup_result = shell_exec($backup_command);

    if ($backup_result === null) {
        return "Erreur lors de la sauvegarde du conteneur.";
    }

    // Restaurer le conteneur à partir de l'image sauvegardée
    $restore_command = "docker run -d --name restored_$container_name $backup_image";
    $restore_result = shell_exec($restore_command);

    if ($restore_result === null) {
        return "Erreur lors de la restauration du conteneur.";
    }

    return "Conteneur sauvegardé et restauré avec succès. Nouveau conteneur restauré : restored_$container_name.";
}

?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Outils de Gestion Docker</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { width: 80%; margin: 0 auto; }
        .button { padding: 10px 20px; background-color: #28a745; color: white; border: none; cursor: pointer; }
        .button:hover { background-color: #218838; }
        .output { margin-top: 20px; padding: 10px; background-color: #f8f9fa; border-radius: 5px; }
    </style>
</head>
<body>



</body>
</html>


