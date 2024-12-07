import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer
import cgi

class RequestHandler(BaseHTTPRequestHandler):
    
    def run_docker_command(self, command):
        """Exécute une commande Docker spécifique"""
        try:
            # Exécution de la commande
            result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            return result.stdout + result.stderr
        except Exception as e:
            return f"Erreur lors de l'exécution de la commande : {e}"

    def do_GET(self):
        """Rend le formulaire pour choisir la catégorie et exécuter une commande"""
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

        html_content = """
            <html>
            <body>
                <h1>Exécution de commandes Docker via Web</h1>
                <div style="width: 100%; height: 300px; border: 2px solid black; padding: 10px;">
                    <h3>Choisissez une catégorie :</h3>
                    <form method="POST" action="/run-command">
                        <button type="submit" name="category" value="1">Création/Installation de conteneurs</button><br><br>
                        <button type="submit" name="category" value="2">Gestion des conteneurs existants</button><br><br>
                    </form>
                    <h3>Sortie de la commande :</h3>
                    <pre id="output" style="background-color: #f0f0f0; height: 100%; overflow-y: scroll;"></pre>
                </div>
            </body>
            </html>
        """
        self.wfile.write(html_content.encode('utf-8'))

    def do_POST(self):
        """Gère l'exécution de la commande en fonction du choix de l'utilisateur"""
        if self.path == '/run-command':
            # Parse the POST data to get the selected category
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            fields = cgi.parse_qs(post_data.decode('utf-8'))
            category = fields.get('category', [''])[0].strip()

            # Sélection des commandes basées sur la catégorie
            if category == "1":
                # Création/Installation de conteneurs
                choice = self.run_creation_commands()
            elif category == "2":
                # Gestion des conteneurs existants
                choice = self.run_management_commands()
            else:
                self.send_response(400)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write("Choix de catégorie invalide.".encode('utf-8'))
                return

            # Exécution des commandes et capture de la sortie
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(choice.encode('utf-8'))

        else:
            self.send_response(404)
            self.end_headers()

    def run_creation_commands(self):
        """Exécute les commandes de création/installation de conteneurs"""
        # Simule l'exécution de différents choix selon la sélection dans le menu
        try:
            # Vous pouvez mettre ici les commandes exactes comme celles que vous avez dans votre script bash
            # Exemple pour "Créer un conteneur HTTPD"
            result = self.run_docker_command("/usr/local/bin/ct-httpd")
            result += self.run_docker_command("/usr/local/bin/ct-setup")
            result += self.run_docker_command("/usr/local/bin/pma")
            result += self.run_docker_command("/usr/local/bin/docker_aio")
            return result
        except Exception as e:
            return f"Erreur lors de l'exécution des commandes : {e}"

    def run_management_commands(self):
        """Exécute les commandes de gestion des conteneurs existants"""
        # Simule l'exécution des commandes liées à la gestion des conteneurs
        try:
            result = self.run_docker_command("/usr/local/bin/ct-connect")
            result += self.run_docker_command("/usr/local/bin/ct-start")
            result += self.run_docker_command("/usr/local/bin/ct-stop")
            result += self.run_docker_command("/usr/local/bin/ct-linux")
            result += self.run_docker_command("/usr/local/bin/network")
            result += self.run_docker_command("/usr/local/bin/remove")
            return result
        except Exception as e:
            return f"Erreur lors de l'exécution des commandes : {e}"

def run(server_class=HTTPServer, handler_class=RequestHandler):
    """Lance le serveur web"""
    server_address = ('', 9999)
    httpd = server_class(server_address, handler_class)
    print('Starting httpd on port 9999...')
    httpd.serve_forever()

if __name__ == "__main__":
    run()
