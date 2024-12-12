<?php
session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer la commande soumise par l'utilisateur
    $userCommand = isset($_POST['dockerCommand']) ? $_POST['dockerCommand'] : '';
    $containerName = isset($_POST['container_name']) ? escapeshellarg($_POST['container_name']) : '';

    // Remplacer les placeholders dynamiques
    $command = str_replace('<?php echo isset($_POST[\'container_name\']) ? $_POST[\'container_name\'] : \'\'; ?>', $containerName, $userCommand);

    // Sauvegarder la commande dans la session
    $_SESSION['command'] = escapeshellcmd($command);

    // Rediriger vers logs.html pour afficher les résultats
    header('Location: logs.html');
    exit;
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
    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker logs <?php echo isset($_POST['container_name']) ? $_POST['container_name'] : ''; ?>">
        <label for="container_name">Nom du conteneur :</label>
        <input type="text" id="container_name" name="container_name" placeholder="Entrez le nom du conteneur" required>
        <input type="submit" class="button" value="Afficher les logs d'un conteneur">
    </form>

    <!-- Ajouter des boutons pour les commandes Docker -->
    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker images">
        <input type="submit" class="button" value="Lister toutes les images Docker">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker ps">
        <input type="submit" class="button" value="Lister tous les conteneurs Docker">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker network ls">
        <input type="submit" class="button" value="Lister tous les réseaux Docker">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker volume ls">
        <input type="submit" class="button" value="Lister tous les volumes Docker">
    </form>

    <form method="post">
        <input type="hidden" name="dockerCommand" value="docker stats --no-stream">
        <input type="submit" class="button" value="Afficher les statistiques Docker">
    </form>
</div>

</body>
</html>
