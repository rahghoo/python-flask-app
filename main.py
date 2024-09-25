from flask import Flask, jsonify, request # type: ignore

app = Flask(__name__)


@app.route('/', methods=['GET'])
def helloworld():
	if(request.method == 'GET'):
		data = {"data": "Hello World!"}
		return jsonify(data)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)