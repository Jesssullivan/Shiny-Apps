"""
Manage multiple single-thead web applications with Flask
WIP by Jess Sullivan
"""

from flask import Flask, send_file, redirect
import subprocess
import time, os

app = Flask(__name__)

# setup workspace #

base_url = 'http://127.0.0.1'
work_path = '/Users/jesssullivan/git/Shiny-Apps/Flask'
os.chdir(work_path)

#  Manage ports #

min_port = 5001
max_port = 5011
max_timeout = 600
all_ports = []

# Run once:
for X in range(min_port, max_port):
    all_ports.append(X)

Active_Ports = {}

"""
# testing only #
def fillports(numfill):
    iport = min_port
    for E in range(numfill):
        iport += 1
        Active_Ports[iport] = time.time() + E
"""


## Manage commands, behavior ##

def bash_command(cmd):
    subprocess.Popen(cmd, shell=True, executable='/bin/bash')


def port_generate():
    if len(Active_Ports) >= max_port - min_port:
        return print('ERROR: Active ports has exceeded max ports- [ ',
                     str(max_port - min_port),
                     ' ] - abort! ')
    else:
        curr_active = list(Active_Ports.keys())
        curr_avail = list(set(all_ports).difference(curr_active))
        return curr_avail[1]


def start_R(portnum, appchoice):
    bash_command(str('Rscript shiny_apps/' + appchoice + '.R ' + str(portnum)))


# Define routes + apps
@app.route('/')
def home():
    return send_file('home.html')


@app.route('/default')
def default():
    tmp_port = port_generate()
    start_R(tmp_port, 'default')
    time.sleep(1)
    return redirect(str(base_url + ':' + str(tmp_port)))


@app.route('/DEM2STL')
def DEM2STL():
    tmp_port = port_generate()
    start_R(tmp_port, 'DEM2STL')
    time.sleep(2)
    return redirect(str(base_url + ':' + str(tmp_port)))


@app.route('/KML2CSV')
def KML2CSV():
    tmp_port = port_generate()
    start_R(tmp_port, 'KML2CSV')
    time.sleep(2)
    return redirect(str(base_url + ':' + str(tmp_port)))


@app.route('/CENTKML')
def CENTKML():
    tmp_port = port_generate()
    start_R(tmp_port, 'CENTKML')
    time.sleep(2)
    return redirect(str(base_url + ':' + str(tmp_port)))


@app.route('/KMLSUBSET')
def KMLSUBSET():
    tmp_port = port_generate()
    start_R(tmp_port, 'KMLSUBSET')
    time.sleep(2)
    return redirect(str(base_url + ':' + str(tmp_port)))
