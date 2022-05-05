import os
from flask import Flask
from flask import redirect
from waitress import serve

app = Flask(__name__)


@app.route('/')
def build():
    os.chdir(os.path.expanduser("~/PAE_web_platform/frontend"))
    os.system("npm install")
    if os.path.isdir("build"):
        os.system("rm -rf build")
    os.system("npm run build")
    os.system("sudo reloadClient")
    return redirect("http://192.168.1.74:81", code=302)

if __name__ == "__main__":
    serve(app, host='0.0.0.0', port=1024)