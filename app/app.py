import os
import urlparse

import redis
from flask import render_template, jsonify, request

from models import app

redis_url = os.getenv('REDISTOGO_URL', 'redis://localhost:6379')
url = urlparse.urlparse(redis_url)
redis = redis.StrictRedis(host=url.hostname, port=url.port, db=0, password=url.password)


@app.route('/')
def home():
    return render_template('index.html')





if __name__ == '__main__':
    app.run(debug=True)