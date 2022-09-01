from flask import Flask, render_template, url_for

import os
import base64
import json
import requests

app = Flask(__name__)

def img_to_data(f_image):
    with open(f_image,'rb') as img:
        img_data =  img.read()
    image_data = base64.b64encode(img_data).decode()
    return image_data


def get_meme():
    meme_url = "https://meme-api.herokuapp.com/gimme"
    meme_data = json.loads(requests.request("GET", meme_url).text)
    meme_title = meme_data["title"]
    meme_subreddit = meme_data["subreddit"]
    meme_author = meme_data["author"]
    meme = meme_data["preview"][-2]
    return meme_title, meme_author, meme_subreddit, meme
    

@app.route("/")
def index():
    meme_title, meme_author, subreddit, meme = get_meme()
    return render_template("meme_index.html",
                           meme_title=meme_title,
                           meme_author=meme_author,
                           meme_pic=meme,
                           subreddit=subreddit)

@app.route("/<all_routes>")
def error_page(all_routes):
    img_data = img_to_data("templates/err_img.jpg")
    return render_template("error_page.html",
                            dir_path=all_routes, 
                            img_data=img_data)

# if __name__ == "__main__":
#     app.run("0.0.0.0",port=8080)
