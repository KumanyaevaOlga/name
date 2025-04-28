from flask import Flask, jsonify
import socket
import datetime
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        'message': 'Hello, CI/CD World!',
        'hostname': socket.gethostname(),
        'time': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    })

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'version': os.environ.get('APP_VERSION', '1.0.0')
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))
