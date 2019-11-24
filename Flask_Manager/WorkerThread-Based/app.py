from flask import Flask, redirect, flash, render_template, url_for, make_response, send_from_directory, request, \
    send_file
import subprocess
import os
from werkzeug.utils import secure_filename
import secrets
import socket
import requests
import time
import threading


# client IDs:
usr_id = ''
id_list = []
id_dict = dict(
    time='',
    path='',
    init_url=''
)


def newclient():
    return secrets.token_hex(15)


# paths:
rootpath = os.path.abspath(os.curdir)
inpath = os.path.join(rootpath, 'uploads')
os.path.relpath(inpath)
outpath = os.path.join(rootpath, 'downloads')
templates = os.path.join(rootpath, 'templates')
rel_templates = os.path.relpath('templates')


# url:
hostname = '127.0.0.1'
hostport = 5000


# define Flask app:
app = Flask(__name__, template_folder=rel_templates)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')
app.secret_key = 'super secret key'
app.config['SESSION_TYPE'] = 'filesystem'
tmp_time = time.time()


def bash_run(cmd):
    subprocess.Popen(cmd,
                     shell=True,
                     executable='/bin/bash')


def checkdirs():
    if not os.path.exists(inpath):
        print('Error: uploads path not found.  Exiting')
        raise SystemExit
    if not os.path.exists(outpath):
        print('Error: downloads path not found.  Exiting')
        raise SystemExit
    if not os.path.exists(templates):
        print('Error: templates path not found.  Exiting')
        raise SystemExit


@app.route('/')
def home():
    return render_template('home.jade', page='Home', tokenID='index')


def uploader(usrpath):
    if request.method == 'POST':
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file:
            f = request.files['file']
            f.save(os.path.join(usrpath, f.filename))


def downloader(usr_dir):
    try:
        if len(os.listdir(usr_dir)) == 0:
            for file in os.listdir(usr_dir):
                if os.path.isfile(os.path.join(usr_dir, file)):
                    return os.path.join(usr_dir, file)
    except:
        time.sleep(.1)


@app.route('/centkml', methods=['GET', 'POST'])
def centkml():
    usr_id = newclient()
    usr_dir = os.path.join(inpath, usr_id)
    if not os.path.exists(usr_dir):
        os.mkdir(usr_dir)
    uploader(usr_dir)
    return render_template('centroid.jade',
                           page='KML Centroid Generator',
                           tokenID=usr_id,
                           download=downloader(usr_dir))

