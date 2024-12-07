import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b"<html><body><h1>Docker Command Execution</h1><pre>")
        result = subprocess.run(['container'], stdout=subprocess.PIPE)
        self.wfile.write(result.stdout)
        self.wfile.write(b"</pre></body></html>")

def run(server_class=HTTPServer, handler_class=RequestHandler):
    server_address = ('', 9999)
    httpd = server_class(server_address, handler_class)
    print('Starting httpd on port 9999...')
    httpd.serve_forever()

if __name__ == "__main__":
    run()