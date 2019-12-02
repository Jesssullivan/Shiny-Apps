#Global packages for STL Converter (raster2stl)
library(r2stl)
library(png)
library(magick)
library(gdalUtils)
library(imager)

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]  # file path from flask
output <- args[2]  # output directory

print(file.path(input))

server <- function(input, output) {
    file.create('tmp.png')
    gdal_translate(input, of='PNG', ot='UInt16', 'tmp.png', r="cubicspline", outsize=c(40,40))
    # gdal_translate(input, ), '/tmp.png'), expand="gray")
    #image = image_read(paste0(dirname(input), '/tmp.tif'))
    #imag <- image_convert(image, format = "png", colorspace = "gray")
    #image_write(imag, paste0(dirname(input), '/tmp.png'))
#    im <- load.image(paste0(dirname(input), '/tmp.png'))
    im <- load.image(paste0(dirname(input),'tmp.png'))
    z <- im[, , 1, 1] 
    x <- 1:length(im[, 1, 1, 1])
    y <- 1:length(im[1, , , 1])
    r2stl(x, y, z, filename = output, object.name = "raster2stl")
}

server(input, output)

# close from within R if possible:
Sys.sleep(2)
quit()
