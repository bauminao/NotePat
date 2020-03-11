#coding: utf-8

from flask import Flask, render_template, request, jsonify
from flask_pymongo import PyMongo

app = Flask(__name__)

app.config["MONGO_DBNAME"] = 'NotePatDB'
app.config["MONGO_URI"]    = 'mongodb://localhost:27017/NotePatDB'
app.config["MONGODB_USER"] = "mongouser"
app.config["MONGODB_PASS"] = "mongopass"

mongo = PyMongo(app)



@app.route("/")
def hello():
    return render_template('index.html')

@app.route("/mongodb", methods=['GET', 'POST', 'DELETE', 'PATCH'])
def mongodb():
    if request.method == 'GET':
        _db = mongo.db.NotePatDB
        output = []
        for _item in _db.find():
            output.append(_item)
        return jsonify({'result' : output})


if __name__ == '__main__':
    app.run(debug=False,host='0.0.0.0')
