from crypt import methods
from flask import Flask, jsonify, request
from waitress import serve

app = Flask(__name__)

@app.route('/')
def get():
    return jsonify({"menssage": "no default GET sucessfully"})

@app.route('/<string:item>')
def getItem(item):
    menssage = "no default GET " + item + " sucessfully"
    return jsonify({"menssage": menssage})

@app.route('/', methods=['POST'])
def post():
    menssage = "no default POST sucessfully"
    return jsonify({"menssage": menssage, "request": request.json})

#UPDATE
@app.route('/<string:item>', methods=['PUT'])
def put(item):
    menssage = "no default PUT " + item + " sucessfully"
    return jsonify({"menssage": menssage})

@app.route('/<string:item>', methods=['DELETE'])
def delete(item):
    menssage = "no default DELETE " + item + " sucessfully"
    return jsonify({"menssage": menssage})

if __name__ == "__main__":
    serve(app, host='0.0.0.0', port=4000)