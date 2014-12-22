from sqlalchemy import Column, Integer, String
from flask import Flask 
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.update(
    SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/test.db',
    SECRET_KEY='my development key',
)
db = SQLAlchemy(app)

class Event(db.Model):
    id = Column(Integer, primary_key=True)
    title = Column(String(100))
    occurs = Column(Integer)

    def __init__(self, title, occurs):
        self.title = title 
        self.occurs = occurs 

    def __repr__(self):
        return '<Event {0}>'.format(self.id)

    def serialize(self):
        return dict(id=self.id, title=self.title, occurs=self.occurs)



if __name__ == "__main__":
    # drop old tables and make new
    db.drop_all()
    db.create_all()


