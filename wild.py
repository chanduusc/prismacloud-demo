import http.server as SimpleHTTPServer
import socketserver as SocketServer
import time
from git import Repo
import os
import shutil, time
time.sleep(10)
dirpath = os.path.join('plz_del')
if os.path.exists(dirpath) and os.path.isdir(dirpath):
    shutil.rmtree(dirpath)
Repo.clone_from("https://github.com/chanduusc/malware.git", "plz_del")
hostName = "0.0.0.0"
serverPort = 8080

class GetHandler(
        SimpleHTTPServer.SimpleHTTPRequestHandler
        ):

    def do_GET(self):
        self.send_response(200, self.headers)
        for h in self.headers:
            self.send_header(h, self.headers[h])
        self.end_headers()


Handler = GetHandler
httpd = SocketServer.TCPServer((hostName, serverPort), Handler)

httpd.serve_forever()