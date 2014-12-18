from sqlalchemy import Column, Integer, String
from flask import Flask 
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.update(
    SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/test.db',
    SECRET_KEY='my development key',
    STATIC_FOLDER='../build'
)
db = SQLAlchemy(app)

class Comment(db.Model):
    id = Column(Integer, primary_key=True)
    author = Column(String(100))
    text = Column(String(250))

    def __init__(self, author, text):
        self.author = author 
        self.text = text 

    def __repr__(self):
        return '<Comment {0}>'.format(self.id)

    def serialize(self):
        
        return dict(id=self.id, author=self.author, text=self.text)



if __name__ == "__main__":
    # drop old tables and make new
    db.drop_all()
    db.create_all()


