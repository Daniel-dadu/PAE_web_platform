import os
from flask import Flask
from flask import redirect
from waitress import serve
from datetime import datetime

app = Flask(__name__)


@app.route('/')
def build():
    print("Builder start ", datetime.now())
    os.chdir(os.path.expanduser("~/PAE_web_platform/frontend"))
    print("Builder change directory")
    os.system("npm install")
    if os.path.isdir("build"):
        print("Builder delete old build")
        os.system("rm -rf build")
    os.system("npm run build")
    print("Builder create new builder")
    os.system("sudo reloadClient")
    print("Builder reload builder ",  datetime.now())
    #la ip de redirect tiene que ser la ip del servidor harcordeada
    return redirect("http://10.50.89.169", code=302)

if __name__ == "__main__":
    serve(app, host='0.0.0.0', port=1024)