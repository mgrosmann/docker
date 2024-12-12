<?php
session_start();

// Fonction principale pour construire et enregistrer la commande Docker
function executeCreationInstallationAction($choix, $container_name, $port, $volume = null, $root_password = null, $user = null, $password = null, $port_pma = null) {
    switch ($choix) {
        case 1:
            return createHttpdContainer($container_name, $port, $volume);
        case 2:
            return createMysqlContainer($container_name, $port, $root_password);
        case 3:
            return createPhpmyadminContainer($container_name, $port_pma, $port, $root_password);
        case 4:
            return createSshSftpContainer($container_name, $port, $user, $password);
        default:
            return "echo 'Choix invalide.'";
    }
}

// Fonctions spécifiques pour chaque type de conteneur
function createHttpdContainer($container_name, $port, $volume = null) {
    $command = "docker container run -d -p $port:80 --name $container_name";
    if ($volume) $command .= " -v $volume:/usr/local/apache2/htdocs";
    $command .= " httpd:latest";
    return $command;
}

function createMysqlContainer($container_name, $port, $root_password) {
    return "docker container run -d -p $port:3306 --name $container_name -e MYSQL_ROOT_PASSWORD=$root_password mysql";
}

function createPhpmyadminContainer($container_name, $port_pma, $port, $root_password) {
    $network_name = "network-$container_name";
    return <<<CMD
docker network create $network_name && \
docker run -d --name sql_$container_name --network $network_name -e MYSQL_ROOT_PASSWORD=$root_password -p $port:3306 mysql:latest && \
docker run -d --name pma_$container_name --network $network_name -e PMA_HOST=sql_$container_name -p $port_pma:80 phpmyadmin/phpmyadmin:latest
CMD;
}

function createSshSftpContainer($container_name, $port, $user, $password) {
    return <<<CMD
docker container run -d -p $port:22 --name $container_name rastasheep/ubuntu-sshd && \
docker exec $container_name bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
CMD;
}

// Traitement du formulaire
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $choix = $_POST['choix'];
    $container_name = $_POST['container_name'];
    $port = $_POST['port'];
    $volume = $_POST['volume'] ?? null;
    $root_password = $_POST['root_password'] ?? null;
    $user = $_POST['user'] ?? null;
    $password = $_POST['password'] ?? null;
    $port_pma = $_POST['port_pma'] ?? null;

    // Construire la commande et l'enregistrer en session
    $command = executeCreationInstallationAction($choix, $container_name, $port, $volume, $root_password, $user, $password, $port_pma);
    $_SESSION['command'] = $command;

    // Rediriger vers logs.html
    header("Location: logs.html");
    exit;
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Création Conteneurs Docker</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        form div { margin-bottom: 15px; }
        label { font-weight: bold; }
        input, select, button { width: 100%; padding: 8px; margin-top: 5px; }
        button { background: #4CAF50; color: white; border: none; cursor: pointer; }
        button:hover { background: #45a049; }
        .hidden { display: none; }
    </style>
    <script>
        function updateForm() {
            const choix = document.getElementById("choix").value;
            document.querySelectorAll(".dynamic-field").forEach(el => el.classList.add("hidden"));

            if (choix === "1") { // Apache HTTPD
                document.getElementById("volume-field").classList.remove("hidden");
            } else if (choix === "2") { // MySQL
                document.getElementById("root-password-field").classList.remove("hidden");
            } else if (choix === "3") { // PhpMyAdmin
                document.getElementById("root-password-field").classList.remove("hidden");
                document.getElementById("port-pma-field").classList.remove("hidden");
            } else if (choix === "4") { // SSH/SFTP
                document.getElementById("user-field").classList.remove("hidden");
                document.getElementById("password-field").classList.remove("hidden");
            }
        }
    </script>
</head>
<body>

<h1>Création Conteneurs Docker</h1>
<form method="post">
    <div>
        <label for="choix">Type de conteneur :</label>
        <select id="choix" name="choix" required onchange="updateForm()">
            <option value="">-- Sélectionner --</option>
            <option value="1">Apache HTTPD</option>
            <option value="2">MySQL</option>
            <option value="3">PhpMyAdmin</option>
            <option value="4">SSH/SFTP</option>
        </select>
    </div>
    <div>
        <label for="container_name">Nom du conteneur :</label>
        <input id="container_name" name="container_name" required>
    </div>
    <div>
        <label for="port">Port :</label>
        <input type="number" id="port" name="port" required>
    </div>
    <div id="volume-field" class="dynamic-field hidden">
        <label for="volume">Volume (optionnel) :</label>
        <input id="volume" name="volume">
    </div>
    <div id="root-password-field" class="dynamic-field hidden">
        <label for="root_password">Mot de passe root :</label>
        <input id="root_password" name="root_password" type="password">
    </div>
    <div id="user-field" class="dynamic-field hidden">
        <label for="user">Utilisateur (SSH) :</label>
        <input id="user" name="user">
    </div>
    <div id="password-field" class="dynamic-field hidden">
        <label for="password">Mot de passe (SSH) :</label>
        <input id="password" name="password" type="password">
    </div>
    <div id="port-pma-field" class="dynamic-field hidden">
        <label for="port_pma">Port PhpMyAdmin :</label>
        <input type="number" id="port_pma" name="port_pma">
    </div>
    <button type="submit">Créer</button>
</form>

</body>
</html>
