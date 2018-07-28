# README:

# Dependencies include:

- GDAL on host machine, make MUST be configured with KML driver — EXPAT driver is currently the choice on my server
    - https://github.com/libexpat/libexpat
    -  See my mildly automated GDAL config script here:  https://github.com/Jesssullivan/rhel-bits — Please follow the shell script # comments before executing.
    - R version “feather spray”, as of init
#  R installs:

R
install.packages(c(“rgdal”, “data.table”, “plyr”, “dplyr”, “tidyverse”))
