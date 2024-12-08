<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer la commande soumise par l'utilisateur
    $userCommand = isset($_POST['dockerCommand']) ? $_POST['dockerCommand'] : '';

    // Sécurisation de la commande pour éviter les injections shell
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

    <form method="post">
        <label for="dockerCommand">Entrez votre commande Docker :</label>
        <input type="text" id="dockerCommand" name="dockerCommand" placeholder="Par exemple : docker container run -d -p 5015:3306 --name maria51 mysql" required>
        <br>
        <input type="submit" class="button" value="Exécuter la commande Docker">
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


