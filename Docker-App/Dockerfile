FROM rocker/shiny

MAINTAINER Jess (jess@sulliwood.org)

# get install files from github
RUN wget https://raw.githubusercontent.com/Jesssullivan/Shiny-Apps/master/Docker-App/Shiny_Docker-Depends.sh \
&& yes | bash ./Shiny_Docker-Depends.sh

RUN wget https://raw.githubusercontent.com/Jesssullivan/Shiny-Apps/master/Docker-App/pkgs.R \
&& pkgs.r -r 'http://cran.rstudio.com' \
    googleAuthR \
    ## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

EXPOSE 8080

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

COPY ./shiny/ /srv/shiny-server/shiny/
