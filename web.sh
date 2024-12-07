#!/bin/bash

# Installer Flask si non installé
apt install pip
if ! pip show flask &> /dev/null; then
    echo "Flask n'est pas installé. Installation..."
    pip install flask
else
    echo "Flask est déjà installé."
fi

# Créer le répertoire de l'application
APP_DIR="/usr/local/bin/docker_web_app"
mkdir -p $APP_DIR/templates

# Créer le script Flask
cat <<EOL > $APP_DIR/app.py
from flask import Flask, render_template, request
import os

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/action', methods=['POST'])
def action():
    option = request.form['option']
    if option == '1':
        os.system('container ct-httpd')
    elif option == '2':
        os.system('container ct-setup')
    elif option == '3':
        os.system('container pma')
    elif option == '4':
        os.system('container docker_aio')
    elif option == '5':
        container_id = request.form['container_id']
        os.system(f'container rm -f {container_id}')
    elif option == '6':
        image_id = request.form['image_id']
        os.system(f'container rmi {image_id}')
    return 'Action exécutée'

if __name__ == '__main__':
    app.run(port=9999)
EOL

# Créer le fichier HTML
cat <<EOL > $APP_DIR/templates/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion de Docker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            color: #333;
        }
        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
        }
        #main {
            background: #fff;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 0 10px #ccc;
        }
        button {
            display: block;
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: none;
            background: #333;
            color: #fff;
            cursor: pointer;
        }
        button:hover {
            background: #555;
        }
    </style>
</head>
<body>
    <div class="container" id="main">
        <h1>Gestion de Docker</h1>
        <form method="POST" action="/action">
            <input type="hidden" name="option" value="1">
            <button type="submit">Créer un conteneur HTTPD</button>
        </form>
        <form method="POST" action="/action">
            <input type="hidden" name="option" value="2">
            <button type="submit">Installer un conteneur multi-service</button>
        </form>
        <form method="POST" action="/action">
            <input type="hidden" name="option" value="3">
            <button type="submit">Créer un conteneur MySQL et phpMyAdmin</button>
        </form>
        <form method="POST" action="/action">
            <input type="hidden" name="option" value="4">
            <button type="submit">Installer un conteneur interactif</button>
        </form>
        <form method="POST" action="/action">
            <input type="hidden" name="option" value="5">
            <input type="text" name="container_id" placeholder="ID/Nom du conteneur à supprimer">
            <button type="submit">Supprimer un conteneur</button>
        </form>
        <form method="POST" action="/action">
            <input type="hidden" name="option" value="6">
            <input type="text" name="image_id" placeholder="ID/Nom de l'image Docker à supprimer">
            <button type="submit">Supprimer une image Docker</button>
        </form>
    </div>
</body>
</html>
EOL

# Donner les permissions d'exécution au script Flask
chmod +x $APP_DIR/app.py

# Démarrer le serveur Flask
echo "Démarrage du serveur Flask sur le port 9999..."
cd $APP_DIR
nohup python3 app.py &

echo "Le serveur web est opérationnel à l'adresse http://localhost:9999"
