<?php
session_start();
require_once 'action.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer le choix de l'utilisateur
    $choix = isset($_POST['choix']) ? $_POST['choix'] : '';

    // Exécuter l'action
    $output = executeOutilsGestionAction($choix);
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

<div class="container">
    <h1>Outils de Gestion Docker</h1>

    <form method="post">
        <button type="submit" name="choix" value="1" class="button">Lister images Docker</button>
        <button type="submit" name="choix" value="2" class="button">Lister les conteneurs Docker</button>
        <button type="submit" name="choix" value="3" class="button">Afficher les journaux Docker</button>
        <button type="submit" name="choix" value="4" class="button">Afficher les statistiques Docker</button>
        <button type="submit" name="choix" value="5" class="button">Lister les réseaux Docker</button>
        <button type="submit" name="choix" value="6" class="button">Lister les volumes Docker</button>
        <button type="submit" name="choix" value="7" class="button">Sauvegarder et restaurer un conteneur</button>
    </form>

    <?php if ($_SERVER['REQUEST_METHOD'] == 'POST'): ?>
        <?php
            $choix = isset($_POST['choix']) ? $_POST['choix'] : '';
            $container_name = isset($_POST['container_name']) ? $_POST['container_name'] : '';

            // Exécution de l'action selon le choix
            $output = executeOutilsGestionAction($choix, $container_name);
        ?>
        <div class="output">
            <h3>Résultat :</h3>
            <pre><?php echo htmlspecialchars($output); ?></pre>
        </div>
    <?php endif; ?>

    <?php if (isset($_POST['choix']) && $_POST['choix'] == 3): ?>
        <form method="post">
            <label for="container_name">Nom ou ID du conteneur (pour les logs) :</label>
            <input type="text" name="container_name" id="container_name" required>
            <button type="submit" name="choix" value="3" class="button">Afficher les logs</button>
        </form>
    <?php endif; ?>

</div>

</body>
</html>

