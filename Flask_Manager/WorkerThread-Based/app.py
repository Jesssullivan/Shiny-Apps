from flask import Flask, redirect, flash, render_template, send_from_directory, request
import subprocess
import os
import secrets
import time
import threading

# global:
verbose = True  # verbose logging?
usrfile = 'usrfile'  # files should already be unique, each is in hashed dir
usr_id = ''  # placeholder for usr hex value


# paths:
rootpath = os.path.abspath(os.curdir)
inpath = os.path.join(rootpath, 'uploads')
os.path.relpath(inpath)
outpath = os.path.join(rootpath, 'downloads')
templates = os.path.join(rootpath, 'templates')
rel_templates = os.path.relpath('templates')
r_apps = os.path.join(rootpath, 'shiny_apps')

# url:
hostname = '127.0.0.1'
hostport = 5000

# define Flask app:
app = Flask(__name__, template_folder=rel_templates, static_url_path=inpath)

# app modifications- using pug/jade, Jinja2 is more common
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')
app.secret_key = 'super secret key'
app.config['SESSION_TYPE'] = 'filesystem'

# recycle directories:
live_app_list = {}
start_time = time.time()
collection_int = 4


def v(message):
    if verbose:
        print(message)


# check upload path before continuing:
if not os.path.exists(inpath):
    v(str('creating upload path ... '))
    os.mkdir(inpath)


def newclient():
    return secrets.token_hex(15)


def uploader(usrpath):  # see Flask docs, verbatim:
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
            f.save(os.path.join(usrpath, usrfile))


def r_thread(infile, outfile, choice):
    cmd = 'Rscript ' + os.path.join(r_apps, choice) + ' ' + infile + ' ' + outfile + ' >> logs.txt'
    subprocess.Popen(cmd,
                     shell=True,
                     executable='/bin/bash',
                     encoding='utf8')


def force_dir_rm(path):
    subprocess.Popen(str('rm -rf ' + path),
                     shell=True,
                     executable='/bin/bash')


def garbageloop():
    while True:
        time.sleep(collection_int)
        for usr in os.listdir(inpath):
            if not usr in live_app_list.keys():
                live_app_list[usr] = time.time()
            if time.time() - live_app_list[usr] > 10:
                try:
                    v('removing expired usr directories...')
                    force_dir_rm(os.path.join(inpath, usr))
                    live_app_list.pop(usr)
                except:
                    v('Error while removing expired usr directory')


# start garbageloop as daemon- operating as a child to Flask server:
init_loop = threading.Thread(target=garbageloop, daemon=True)
init_loop.start()


@app.route('/')
def home():
    return render_template('home.jade', page='Home', tokenID='index')


""" Centroid App: """  # TODO: need an app class or something to organize all the other apps


@app.route('/centdownload', methods=['GET', 'POST'])
def centdownload():
    req = request.form.get('name')
    response = send_from_directory(os.path.join(inpath, req), filename='centroid.kml')
    response.headers["Content-Disposition"] = "attachment; filename=centroid.kml"
    return response


@app.route('/centkml', methods=['GET', 'POST'])
def centkml():
    outname = 'centroid.kml'
    usr_id = newclient()
    usr_dir = os.path.join(inpath, usr_id)

    if not os.path.exists(usr_dir):
        os.mkdir(usr_dir)

    # prepare to receive upload:
    uploader(usr_dir)

    # while at url, run script after upload:
    if len(os.listdir(usr_dir)) > 0:
        r_thread(infile=os.path.join(usr_dir, usrfile),
                 outfile=os.path.join(usr_dir, outname),
                 choice='centkml.R')

    # template is returned immediately, regardless of upload:
    return render_template('centroid.jade',
                           page='KML Centroid Generator',
                           tokenID=usr_id)

