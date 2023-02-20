from http.server import BaseHTTPRequestHandler, HTTPServer
import time
from git import Repo
import os,platform,boto3
import shutil, time
import uuid,datetime
time.sleep(10)
dirpath = os.path.join('plz_del')
if os.path.exists(dirpath) and os.path.isdir(dirpath):
    shutil.rmtree(dirpath)
Repo.clone_from("https://github.com/chanduusc/malware.git", "plz_del")
unique_bucketname = 'cnappdemo/' + str(uuid.uuid4().hex)+ '-' + str(datetime.datetime.now().time()).replace(':', '-').replace('.', '-')
cloud_provider = platform.uname()[2]
if 'amzn' in cloud_provider:
    s3 = boto3.resource('s3')
    s3.meta.client.upload_file('/plz_del/FritzFrog/001eb377f0452060012124cb214f658754c7488ccb82e23ec56b2f45a636c859', unique_bucketname , '001eb377f0452060012124cb214f658754c7488ccb82e23ec56b2f45a636c859')
elif 'azure' in cloud_provider:
    next
else:
    next
hostName = "0.0.0.0"
serverPort = 8080
class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>Prisma Cloud Demo</title></head>", "utf-8"))
        self.wfile.write(bytes("<p>Host Requested: %s</p>" % self.headers.get('Host'), "utf-8"))
        self.wfile.write(bytes("<p>XFF Requested: %s</p>" % self.headers.get("X-Forwarded-For"), "utf-8"))
        self.wfile.write(bytes("<p>Command: %s</p>" % self.command, "utf-8"))
        self.wfile.write(bytes("<p>HTTP Req version: %s</p>" % self.request_version, "utf-8"))
        self.wfile.write(bytes("<p>Path: %s</p>" % self.path, "utf-8"))
        self.wfile.write(bytes("<p>Requestor: %s</p>" % self.request.getpeername()[0], "utf-8"))
        self.wfile.write(bytes("<body>", "utf-8"))
        self.wfile.write(bytes("<p>Demo Server</p>", "utf-8"))
        self.wfile.write(bytes("</body></html>", "utf-8"))
    def do_OPTIONS(self):
        self.send_response(200, "ok")
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header("Access-Control-Allow-Headers", "X-Requested-With")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()
  

if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")