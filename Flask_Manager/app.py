"""
Manage multiple single-thead web applications with Flask
WIP by Jess Sullivan
"""

from flask import Flask, send_file, redirect
import subprocess
import time, os
import threading

app = Flask(__name__)

# setup workspace #

base_url = 'http://127.0.0.1'
# work_path = ''
# os.chdir(work_path)

#  Manage ports #

min_port = 5001
max_port = 5011
max_timeout = 5 # in secs
all_ports = []

# Run once:
for X in range(min_port, max_port):
    all_ports.append(X)

Active_Ports = {}

# testing only #
def fillports(numfill):
    iport = min_port
    for E in range(numfill):
        iport += 1
        Active_Ports[iport] = time.time() + E


## Manage commands, behavior ##

def bash_run(cmd):
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


def start_R(appchoice):
    portnum = port_generate()
    bash_run(str('Rscript shiny_apps/' + appchoice + '.R ' + str(portnum)))
    Active_Ports[portnum] = time.time()
    time.sleep(2)
    return redirect(str(base_url + ':' + str(portnum)))

# TODO: Kill ports after max_timout
"""
tmp_time = time.time()
def check_ports(tmp_time):

    # check live ports:
    tmp_keys = list(Active_Ports.keys())
    for D in tmp_keys:
        if Active_Ports[D] >= tmp_time + max_timeout:
            bash_run(str('kill ' + str(D)))
            tmp_time = time.time()
            print(str('killed app on port ' + str(D) +
                    'max time exceeded'))

    threading.Timer(3, check_ports).start()

check_ports(tmp_time)
"""
# Define routes + apps
@app.route('/')
def home():
    return send_file('home.html')

@app.route('/default')
def default():
    return start_R('default')

@app.route('/DEM2STL')
def DEM2STL():
    return start_R('DEM2STL')

@app.route('/KML2CSV')
def KML2CSV():
    return start_R('KML2CSV')

@app.route('/CENTKML')
def CENTKML():
    return start_R('CENTKML')

@app.route('/KMLSUBSET')
def KMLSUBSET():
    return start_R('KMLSUBSET')

