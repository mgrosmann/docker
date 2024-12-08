<?php
session_start();
require_once 'action.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer les informations du formulaire
    $choix = isset($_POST['choix']) ? $_POST['choix'] : '';
    $container_name = isset($_POST['container_name']) ? $_POST['container_name'] : '';

    // Exécuter l'action en fonction du choix
    $output = executeGestionConteneursAction($choix, $container_name);
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Conteneurs</title>
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
    <h1>Gestion des Conteneurs</h1>

    <form method="post">
        <button type="submit" name="choix" value="1" class="button">Se connecter à un conteneur</button>
        <button type="submit" name="choix" value="2" class="button">Démarrer tous les conteneurs</button>
        <button type="submit" name="choix" value="3" class="button">Arrêter tous les conteneurs</button>
        <button type="submit" name="choix" value="4" class="button">Installer nano et wget sur un conteneur</button>
        <button type="submit" name="choix" value="5" class="button">Recréer réseaux Docker</button>
        <button type="submit" name="choix" value="6" class="button">Supprimer conteneurs arrêtés</button>
        <button type="submit" name="choix" value="7" class="button">Recréer conteneurs</button>

        <?php 
        // Afficher le champ pour le nom du conteneur et le bouton uniquement pour les options "1" et "4"
        if (isset($_POST['choix']) && in_array($_POST['choix'], [1, 4])): ?>
            <br><br>
            <label for="container_name">Nom du conteneur :</label>
            <input type="text" name="container_name" id="container_name" required><br><br>
            <button type="submit" name="choix" value="<?php echo $_POST['choix']; ?>" class="button">Soumettre</button>
        <?php endif; ?>
    </form>

    <?php if (isset($output)): ?>
        <div class="output">
            <h3>Résultat :</h3>
            <pre><?php echo htmlspecialchars($output); ?></pre>
        </div>
    <?php endif; ?>

</div>

</body>
</html>

