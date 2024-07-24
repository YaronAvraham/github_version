from flask import Flask, jsonify
import requests

app = Flask(__name__)

@app.route('/<user>/<repo>', methods=['GET'])
def get_latest_release(user, repo):
    
    url = f'https://api.github.com/repos/{user}/{repo}/releases/latest'
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        return jsonify({'latest_version': data['tag_name']})
    else:
        return jsonify({'error': 'Repository not found'}), 404

if __name__ == '__main__':
    # Run the Flask app on 0.0.0.0:8080 to listen on all network interfaces
    app.run(host='0.0.0.0', port=8080)
