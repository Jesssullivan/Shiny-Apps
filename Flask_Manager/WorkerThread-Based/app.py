from flask import Flask, redirect, request, flash, render_template
import subprocess
import os
from werkzeug.utils import secure_filename

inpath = os.path.abspath('uploads')
outpath = os.path.abspath('downloads')
templates = 'templates'

app = Flask(__name__, template_folder=templates)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')

def uploader():
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
            f.save(os.path.join(inpath, secure_filename(f.filename)))


@app.route('/')
def home():
    return render_template('home.jade')


def bash_run(cmd):
    subprocess.Popen(cmd,
                     shell=True,
                     executable='/bin/bash')


@app.route('/CENTKML')
def cent_kml():
    return render_template('centroid.jade')


