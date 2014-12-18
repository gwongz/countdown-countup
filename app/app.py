import os
import json
import urlparse
import urllib
import shutil
from StringIO import StringIO

import redis
import requests
from PIL import Image 
from flask import render_template, jsonify, request
from bs4 import BeautifulSoup
from models import app

redis_url = os.getenv('REDISTOGO_URL', 'redis://localhost:6379')
url = urlparse.urlparse(redis_url)
redis = redis.StrictRedis(host=url.hostname, port=url.port, db=0, password=url.password)

# redis.set('myurl', 'http://www.sweatguru.com')
# redis.get('myurl')

def seed_images():

    image_source = "https://unsplash.com/"
    response = requests.get(image_source)
    soup = BeautifulSoup(response.content)
    imgs = soup.findAll("img")
    count = 1
    # imgs = soup.findAll("div", {"class":"photo"})
    for img in imgs:
        link = img["src"]
        credit = img["alt"]
        print img["src"]
        redis.set(link, credit)
        save_image(link, count=count)
        count += 1

def save_image(link, count, destdir="static/images/bg"):
    
    if not os.path.exists(destdir):
        os.mkdir(destdir)
    name = 'bg{count}'.format(count=count)
    out_file = '{0}/{1}.jpg'.format(destdir, name)
    urllib.urlretrieve(link, out_file)

def post_comment():
    author = request.json["author"]
    text = request.json["text"]
    comment = Comment(author, text)
    db.session.add(comment)
    db.session.commit()
    return 'Ok'


@app.route('/')
def home():
    return render_template('index.html')

@app.route('/comments', methods=['POST', 'GET'])
def comments():
    if request.method == 'POST':
        return post_comment()
    else:
        comments = Comment.query.all()
        return json.dumps([c.serialize() for c in comments])
    # return [jsonify(author=comments.author, text=comments.text)]



if __name__ == '__main__':
    # seed_images()
    app.run(debug=True)