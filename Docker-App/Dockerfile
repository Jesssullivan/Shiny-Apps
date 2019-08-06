FROM rocker/shiny

MAINTAINER Jess (jess@sulliwood.org)

# install stuff
RUN yes | bash ./Shiny_Docker-Depends.sh

RUN pkgs.r -r 'http://cran.rstudio.com' \
    googleAuthR \
    ## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

EXPOSE 8080

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

COPY ./shiny/ /srv/shiny-server/shiny/
