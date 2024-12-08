<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer la commande soumise par l'utilisateur
    $userCommand = isset($_POST['dockerCommand']) ? $_POST['dockerCommand'] : '';
    $command = escapeshellcmd($userCommand);

    // Variables pour afficher les logs et erreurs
    $output = '';
    $error = '';
    $status = null;

    // Exécuter la commande et capturer la sortie, rediriger stderr vers stdout pour avoir toute la sortie dans $output
    exec($command . ' 2>&1', $output, $status);

    // Vérifier si la commande a échoué
    if ($status !== 0) {
        // Ajouter le message d'erreur
        $error = 'Erreur lors de l\'exécution de la commande Docker :';
    }

    // Les logs doivent être affichés, même si la commande échoue
    $output = implode("\n", $output); // On formatte la sortie pour un affichage lisible
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exécution de la commande Docker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .container {
            width: 80%;
            margin: 0 auto;
        }
        h1 {
            color: #333;
        }
        .button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            font-size: 16px;
            cursor: pointer;
        }
        .button:hover {
            background-color: #218838;
        }
        .output, .error {
            margin-top: 20px;
            padding: 10px;
            border-radius: 5px;
            background-color: #f8f9fa;
            border: 1px solid #ccc;
        }
        .output {
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Exécuter la commande Docker</h1>

    <!-- Ajouter des boutons pour les autres commandes Docker -->
    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker container exec -it <?php echo isset($_POST['container_name']) ? $_POST['container_name'] : ''; ?> /bin/bash">
        <input type="submit" class="button" value="Exécuter un shell dans le conteneur">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="bash start.sh">
        <input type="submit" class="button" value="Démarrer tous les conteneurs">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="bash stop.sh">
        <input type="submit" class="button" value="Arrêter tous les conteneurs">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker exec -it <?php echo isset($_POST['container_name']) ? $_POST['container_name'] : ''; ?> apt-get install nano wget">
        <input type="submit" class="button" value="Installer nano et wget sur un conteneur">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="network">
        <input type="submit" class="button" value="Vérifier et recréer les réseaux Docker">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker rm $(docker ps -a -q -f status=exited)">
        <input type="submit" class="button" value="Supprimer tous les conteneurs arrêtés">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker-compose up --force-recreate -d">
        <input type="submit" class="button" value="Recréer les conteneurs arrêtés">
    </form>

    <?php if ($_SERVER['REQUEST_METHOD'] == 'POST'): ?>
        <div class="output">
            <h2>Logs de la commande Docker :</h2>
            <pre><?php echo htmlspecialchars($output); ?></pre>
        </div>
        
        <?php if ($error): ?>
            <div class="error">
                <h2>Erreur :</h2>
                <pre><?php echo htmlspecialchars($error); ?></pre>
            </div>
        <?php endif; ?>
    <?php endif; ?>
</div>

</body>
</html>

