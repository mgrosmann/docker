<?php
session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Sauvegarder la catégorie sélectionnée dans la session
    $categorie = isset($_POST['categorie']) ? $_POST['categorie'] : '';
    $_SESSION['categorie'] = $categorie;  // Sauvegarde dans la session

    // Redirection vers le fichier correspondant à la catégorie choisie
    if ($categorie == 1) {
        header('Location: creation_installation.php');
    } elseif ($categorie == 2) {
        header('Location: gestion_conteneurs.php');
    } elseif ($categorie == 3) {
        header('Location: outils_gestion.php');
    } elseif ($categorie == 4) {
        header('Location: test.php');  // Redirection vers test.php pour le bouton "Exécuteur de commande"
    }
    exit();
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Docker via Web</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { width: 80%; margin: 0 auto; }
        .button { padding: 10px 20px; background-color: #28a745; color: white; border: none; cursor: pointer; }
        .button:hover { background-color: #218838; }
    </style>
</head>
<body>

<div class="container">
    <h1>Gestion Docker via Interface Web</h1>

    <form method="post">
        <label for="categorie">Choisir une catégorie :</label><br>
        <button type="submit" name="categorie" value="1" class="button">Création/Installation de conteneurs</button>
        <button type="submit" name="categorie" value="2" class="button">Gestion des conteneurs</button>
        <button type="submit" name="categorie" value="3" class="button">Outils de gestion Docker</button>
        <button type="submit" name="categorie" value="4" class="button">Exécuteur de commande</button>  <!-- Nouveau bouton -->
    </form>
</div>

</body>
</html>

