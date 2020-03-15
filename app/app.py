#coding: utf-8

from flask import Flask, render_template, request, jsonify
from flask_pymongo import PyMongo

from bson import json_util
import json

app = Flask(__name__)

app.config["MONGO_DBNAME"] = 'NotePatDB'
app.config["MONGO_URI"]    = 'mongodb://localhost:27017/NotePatDB'
app.config["MONGODB_USER"] = "mongouser"
app.config["MONGODB_PASS"] = "mongopass"

mongo = PyMongo(app)



@app.route("/", methods=['GET', 'POST', 'DELETE'])
def hello():
    if request.method == 'GET':
      return render_template('index.html')

@app.route("/mongodb", methods=['GET', 'POST', 'DELETE', 'PATCH'])
def mongodb():
    if request.method == 'GET':
        _notes = mongo.db.notes
        output = []
        for _item in _notes.find():
            _myjson = _item
            print ("Debug:")
            print (_myjson.pop('_id'))
            output.append(_myjson)
        print (output)
        return jsonify(output)

@app.route("/mongo2", methods=['GET', 'POST', 'DELETE', 'PATCH'])
def mongodb2():
    if request.method == 'GET':
        _notes = mongo.db.notes
        output = []
        for _item in _notes.find():
            output.append(_item)
        #return json.dumps(output, sort_keys=True, indent=4)
        return (jsonify(json.loads(json_util.dumps(output))))

@app.route("/init", methods=['GET'])
def init_db():
    if request.method == 'GET':
        _notes = mongo.db.notes
        OneNote = {"Prio" : 1 , "title" : "Test Init data"}

        recordID = _notes.insert(OneNote)
        print ("Record ID: " + str(recordID))
        return str(recordID)



if __name__ == '__main__':
    app.run(debug=False,host='0.0.0.0')
