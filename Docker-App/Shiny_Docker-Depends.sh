#!/bin/bash
add-apt-repository universe
add-apt-repository multiverse
apt update
apt upgrade
apt install python git gdebi-core gconf2 gconf-service
# Java / rJava /GDAL depends
apt install default-jre default-jdk
apt-get install r-base-dev libgdal-dev libssl-dev
apt-get install libxml2-dev libcurl4-openssl-dev libudunits2-dev
R CMD javareconf
apt --fix-broken install
