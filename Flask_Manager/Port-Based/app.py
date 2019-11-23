from flask import Flask, send_file, redirect  # site structure
import subprocess  # spawn apps
import time  # general
import re
import threading  # spawn port daemon
from sys import argv  # check CLI arguments

"""
Manage multiple web applications on separate ports 
WIP by Jess Sullivan 

Depends:
pip3 install flask  
    Flask provides site structure and 302 redirects to spawned ports. 
"""

# configurable server variables:

cmds = False  # show configurable variables?
verbose = True  # enable verbose logs?

max_port_timeout = 30  # thread on port max. lifetime
daemon_interval = 10  # seconds between port time checks
min_port = 5001  # min. allocated port in range for spawned apps
max_port = 5011  # max. allocated port in range for spawned apps

# global:
all_ports = []
Active_Ports = {}
base_url = 'http://127.0.0.1'

# define server variables from CLI:
cmd_args = argv

if cmds:  # CLI help:
    print(str('cmd defaults, in order: \n' +
              'v = True  # enable verbose logs? \n' +
              'max_port_timeout = ' + str(max_port_timeout) + '  # in secs \n' +
              'daemon_interval = ' + str(max_port_timeout) + ' #  in secs \n' +
              'min_port = 5001  # min. allocated port in range for spawned apps \n' +
              'max_port = 5011  # max. allocated port in range for spawned apps \n'))

""" Manage commands, behavior """


def v(message):
    if verbose:
        print(message)


def bash_run(cmd):
    subprocess.Popen(cmd,
                     shell=True,
                     executable='/bin/bash')


def port_generate():
    if len(Active_Ports) >= max_port - min_port:
        return v(str('ERROR: Active ports has exceeded max ports- [ ' +
                     str(max_port - min_port) +
                     ' ] - abort '))

    else:
        curr_active = list(Active_Ports.keys())
        curr_avail = list(set(all_ports).difference(curr_active))
        return curr_avail[1]


def start_r(app_choice):
    port_num = port_generate()
    bash_run(str('Rscript shiny_apps/' + app_choice + '.R ' + str(port_num)))
    Active_Ports[port_num] = time.time()
    time.sleep(2)
    return redirect(str(base_url + ':' + str(port_num)))


""" Define port manager """

tmp_time = time.time()


def check_ports():

    global tmp_time

    pre_keys = list(Active_Ports.keys())
    v('checking ports...')

    if len(pre_keys) > 0:

        for port in pre_keys:

            if Active_Ports[port] >= tmp_time + max_port_timeout:
                tmp_time = time.time()
                v(str('killing app on port ' + str(port) +
                      ' max time exceeded...'))

                cmd = 'lsof -i:' + str(port) + ' -t'
                output = subprocess.run([cmd],
                                        shell=True,
                                        executable='/bin/bash',
                                        stdout=subprocess.PIPE)

                tokill = str(output.stdout).split('\\')

                for p in range(len(tokill)):
                    ex = re.sub("[^0-9]", '', tokill[p])
                    v(str('attempting to kill port ' + str(ex)))

                    # kill -9:
                    try:
                        if len(ex) > 2:
                            bash_run(str(' kill -9 ' + str(ex)))

                    except:
                        v(str('skipping kill port ' + str(ex)))

                Active_Ports.pop(port)  # removes killed process from dict

    post_keys = list(Active_Ports.keys())

    v(str('ports checked \n' +
          'active app ports: ' + str(len(post_keys)) + '\n' +
          'ports currently working: ' + str(post_keys)))


""" Start Port Checking """


def daemon_loop():
    while True:
        time.sleep(daemon_interval)
        print('checking...')
        check_ports()


for X in range(min_port, max_port):
    all_ports.append(X)

init_loop = threading.Thread(target=daemon_loop, daemon=True)
init_loop.start()

""" Define Flask app """

app = Flask(__name__)


@app.route('/')
def home():
    return send_file('home.html')


@app.route('/default')
def default():
    return start_r('default')


@app.route('/DEM2STL')
def dem2stl():
    return start_r('dem2stl')


@app.route('/KML2CSV')
def kml2stl():
    return start_r('kml2csv')


@app.route('/CENTKML')
def cent_kml():
    return start_r('centkml')


@app.route('/KMLSUBSET')
def kml_subset():
    return start_r('kmlsubset')
