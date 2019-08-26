import time
import threading
import subprocess
import sys

min_port = 5001
max_port = 5011
max_timeout = 5  # in secs
all_ports = []
Active_Ports = {}

# Run once:
for X in range(min_port, max_port):
    all_ports.append(X)


def bash_run(cmd):
    subprocess.Popen(cmd, shell=True, executable='/bin/bash')


tmp_time = time.time()


def check_threads(tmp_time):
    # check live ports:
    tmp_keys = list(Active_Ports.keys())
    for D in tmp_keys:
        if Active_Ports[D] >= tmp_time + max_timeout:
            tmp_time = time.time()
            print(str('killing app on port ' + str(D) +
                      ' max time exceeded...'))
            bash_run(str('kill $(lsof - t - i:' + str(D) + ')'))


check_threads(tmp_time)

# sys.exit()
