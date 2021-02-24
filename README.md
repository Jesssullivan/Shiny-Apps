# **Web Apps in R / Shiny**

Simple web utilities for GIS tasks.

Process manager experiments for R threads in [/Flask-Manager](/Flask-Manager).   

Visit the [single threaded example here](https://kml-tools.herokuapp.com/); (Not load balanced, just for an example view).  These are wrapped in a Node.JS application on Heroku, which loads each utility through [shinyapps.io](https://www.shinyapps.io/).  These functions are hosted entirely through (Heroku / shinyapps) free tiers.

See /[Docker-App](https://github.com/Jesssullivan/Shiny-Apps/tree/master/Docker-App) for deployment in the GCP app engine.

- Raster2stl - converts raster data (image- a .jpg taken from a DEM file for instance) to a 3d STL file showing exagerated terrain.  (added 3/6/19)  
- KML2SHP_Converter - generates a zip archive of shape files based on KML file layers
- Centroid_KML - "KML-Centroid-Generator"
- KML2CSV - converts KML (XML) to .csv spreadsheet format
- KMLSubsetFilter - from a KML file, this tool returns a subset KML based on two query strings (searches the description field of the KML)


- - -


*Misc*


[![ ](https://img.youtube.com/vi/79XI5FTxD2E/0.jpg)](https://www.youtube.com/watch?v=79XI5FTxD2E)

[![ ](https://img.youtube.com/vi/sf7rDg86CJE/0.jpg)](https://www.youtube.com/watch?v=sf7rDg86CJE)


*See http://www.transscendsurvival.org/ for related info on my blog*
