"""
Manage multiple single-thead web applications with Flask
WIP by Jess Sullivan
"""
import os

# set WD:
work_path = '/Users/jesssullivan/Shiny-Apps'
os.chdir(work_path)

from flask import Flask, send_file, redirect
from Flask_Manager.daemon import Active_Ports, min_port, \
    max_port, all_ports, bash_run
import time

app = Flask(__name__)

base_url = 'http://127.0.0.1'


## Manage commands, behavior ##

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
    bash_run(str('Rscript Flask_Manager/shiny_apps/' + appchoice + '.R ' + str(portnum)))
    Active_Ports[portnum] = time.time()
    time.sleep(2)
    return redirect(str(base_url + ':' + str(portnum)))


# Define routes + apps
@app.route('/')
def home():
    return send_file('Flask_Manager/home.html')


@app.route('/default')
def default():
    return start_R('default')


@app.route('/DEM2STL')
def DEM2STL():
    return start_R('Flask_Manager/shiny_apps/DEM2STL')


@app.route('/KML2CSV')
def KML2CSV():
    return start_R('Flask_Manager/shiny_apps/KML2CSV')


@app.route('/CENTKML')
def CENTKML():
    return start_R('Flask_Manager/shiny_apps/CENTKML')


@app.route('/KMLSUBSET')
def KMLSUBSET():
    return start_R('/Flask_Manager/shiny_apps/KMLSUBSET')


"""
# testing only #
def fillports(numfill):
    iport = min_port
    for E in range(numfill):
        iport += 1
        Active_Ports[iport] = time.time() + E
"""
