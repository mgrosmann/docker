<?php

function executeCreationInstallationAction($choix, $container_name, $port, $volume = null, $root_password = null, $repertory = null, $user=null, $password=null, $port_pma=null ) {
    // Exemple d'implémentation
    switch ($choix) {
        case 1:  // HTTPD - Conteneur Apache HTTPD
            return createHttpdContainer($container_name, $port, $volume);
        case 2:  // MySQL - Conteneur MySQL
            return createMysqlContainer($container_name, $port, $root_password);
        case 3:  // PhpMyAdmin - Conteneur PhpMyAdmin
            return createPhpmyadminContainer($container_name, $port_pma, $port, $root_password);
        case 4:  // SSH/SFTP - Conteneur SSH
            return createSshSftpContainer($container_name, $port, $user, $password);
        default:
            return "Choix invalide.";
    }
}

function createHttpdContainer($container_name, $port, $volume = null) {
    $command = " docker container run -d -p $port:80 --name $container_name httpd";
    if ($volume) {
        $command .= " -v $volume:/usr/local/apache2/htdocs";
    }
    $command .= " httpd:latest";
    return shell_exec($command);  // Exécuter la commande shell
}

function createMysqlContainer($container_name, $port, $root_password) {
    $command = "docker container run -d -p $port:3306 --name $container_name -e MYSQL_ROOT_PASSWORD=$root_password mysql";
    return shell_exec($command);
}

function createPhpmyadminContainer($container_name, $port_pma, $port, $root_password) {
    $network_name = "network-$container_name";
    $command = <<<CMD
docker network create $network_name && \
docker run -d --name sql_$container_name --network $network_name -e MYSQL_ROOT_PASSWORD=$root_password -p $port:3306 mysql:latest && \
docker run -d --name pma_$container_name --network $network_name -e PMA_HOST=sql_$container_name -p $port_pma:80 phpmyadmin/phpmyadmin:latest
CMD;
    return shell_exec($command);
}


function createSshSftpContainer($container_name, $port, $user, $password) {
    $command = <<<CMD
docker container run -d -p $port:22 --name $container_name rastasheep/ubuntu-sshd && \
docker exec $container_name bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
CMD;
    return shell_exec($command);
}

?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Installation/Création de conteneurs</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #4CAF50; }
        .container { margin: 20px 0; }
        label { font-weight: bold; }
        input[type="text"], input[type="number"], select { padding: 8px; width: 100%; margin: 10px 0; }
        button { background-color: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        button:hover { background-color: #45a049; }
    </style>
</head>
<body>

<h1>Création/Installation de Conteneurs Docker</h1>

<form action="creation_installation.php" method="post">
    <div class="container">
        <label for="choix">Choisissez le type de conteneur :</label>
        <select name="choix" id="choix">
            <option value="1">Apache HTTPD</option>
            <option value="2">MySQL</option>
            <option value="3">PhpMyAdmin</option>
            <option value="4">SSH/SFTP</option>
        </select>
    </div>

    <div class="container">
        <label for="container_name">Nom du conteneur :</label>
        <input type="text" id="container_name" name="container_name" required>
    </div>

    <div class="container" id="port-container" style="display:none;">
        <label for="port">Port à utiliser (si pma choisi, alors port sql):</label>
        <input type="number" id="port" name="port" required>
    </div>

    <div class="container" id="volume-container" style="display:none;">
        <label for="volume">Répertoire (volume) à monter (optionnel) :</label>
        <input type="text" id="volume" name="volume">
    </div>

    <div class="container" id="root_password-container" style="display:none;">
        <label for="root_password">Mot de passe root MySQL (si MySQL) :</label>
        <input type="text" id="root_password" name="root_password">
    </div>

    <div class="container" id="repertory-container" style="display:none;">
        <label for="repertory">Répertoire pour PhpMyAdmin (optionnel) :</label>
        <input type="text" id="repertory" name="repertory">
    </div>

    <div class="container" id="user-container" style="display:none;">
        <label for="user">Utilisateur pour SSH/SFTP (optionnel) :</label>
        <input type="text" id="user" name="user">
    </div>

    <div class="container" id="password-container" style="display:none;">
        <label for="password">Mot de passe pour SSH/SFTP (optionnel) :</label>
        <input type="text" id="password" name="password">
    </div>

    <div class="container" id="port_pma-container" style="display:none;">
        <label for="port_pma">Port pour PhpMyAdmin (optionnel) :</label>
        <input type="number" id="port_pma" name="port_pma">
    </div>
    
    <button type="submit">Créer le conteneur</button>
</form>

<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer les valeurs du formulaire
    $choix = $_POST['choix'];
    $container_name = $_POST['container_name'];
    $port = $_POST['port'];
    $volume = isset($_POST['volume']) ? $_POST['volume'] : null;
    $root_password = isset($_POST['root_password']) ? $_POST['root_password'] : null;
    $repertory = isset($_POST['repertory']) ? $_POST['repertory'] : null;
    $user = isset($_POST['user']) ? $_POST['user'] : null;
    $password = isset($_POST['password']) ? $_POST['password'] : null;
    $port_pma = isset($_POST['port_pma']) ? $_POST['port_pma'] : null;

    // Exécuter la fonction en fonction du choix
    $result = executeCreationInstallationAction($choix, $container_name, $port, $volume, $root_password, $repertory, $user, $password, $port_pma, $port);
    echo "<p><strong>Résultat :</strong> $result</p>";
}
?>

<script>
    // Affichage dynamique des champs selon le choix du conteneur
    const choixElement = document.getElementById('choix');
    const portElement = document.getElementById('port');
    const portcontainer = document.getElementById('port-container');
    const volumeContainer = document.getElementById('volume-container');
    const rootPasswordContainer = document.getElementById('root_password-container');
    const repertoryContainer = document.getElementById('repertory-container');
    const userContainer = document.getElementById('user-container');
    const passwordContainer = document.getElementById('password-container');
    const portPmaContainer = document.getElementById('port_pma-container');

    choixElement.addEventListener('change', function () {
    const choix = parseInt(choixElement.value, 10);

    // Réinitialiser tous les champs
    portcontainer.style.display = 'none';
    volumeContainer.style.display = 'none';
    rootPasswordContainer.style.display = 'none';
    repertoryContainer.style.display = 'none';
    userContainer.style.display = 'none';
    passwordContainer.style.display = 'none';
    portPmaContainer.style.display = 'none';

    // Activer les champs pertinents selon le choix
    if (choix === 1) {
        portcontainer.style.display = 'block';
        volumeContainer.style.display = 'block';
    } else if (choix === 2) {
        portcontainer.style.display = 'block';
        rootPasswordContainer.style.display = 'block';
    } else if (choix === 3) {
        portcontainer.style.display = 'block'; 
        portPmaContainer.style.display = 'block';
        rootPasswordContainer.style.display = 'block';
    } else if (choix === 4) {
        portcontainer.style.display = 'block';
        userContainer.style.display = 'block';
        passwordContainer.style.display = 'block';
    }
});

</script>

</body>
</html>

