<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer la commande soumise par l'utilisateur
    $userCommand = isset($_POST['dockerCommand']) ? $_POST['dockerCommand'] : '';

    // Sécurisation de la commande pour éviter les injections shell
    $command = escapeshellcmd($userCommand);

    // Sauvegarder la commande dans une session pour l'exécuter en arrière-plan
    session_start();
    $_SESSION['command'] = $command;
    session_write_close();

    // Rediriger vers une page d'exécution en temps réel
    header('Location: execute.php');
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
        <label for="dockerCommand">Entrez votre commande Docker :</label>
        <input type="text" id="dockerCommand" name="dockerCommand" placeholder="Par exemple : docker container run -d -p 5015:3306 --name maria51 mysql" required>
        <br>
        <input type="submit" class="button" value="Exécuter la commande Docker">
    </form>
</div>

</body>
</html>
