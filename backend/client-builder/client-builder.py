import os
from flask import Flask
from flask import redirect
from waitress import serve

app = Flask(__name__)


@app.route('/')
def build():
    os.chdir("./builder/frontend")
    os.system("npm install")
    if os.path.isdir("build"):
        os.system("rm -r build")
    os.system("npm run build")
    return os.getcwd()#redirect("https://www.google.com/", code=302)

if __name__ == "__main__":
    serve(app, host='0.0.0.0', port=1024)