#Global packages for STL Converter (raster2stl)
library(r2stl)
library(png)
library(magick)

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]  # file path from flask
output <- args[2]  # output directory

server <- function(input, output) {
    image = image_read(input)
    imag <- image_convert(image, format = "png", colorspace = "gray")
    ima <- image_write(imag, "tmp.png")
    im <- load.image("tmp.png")
    z <- im[, , 1, 1]
    x <- 1:length(im[, 1, 1, 1])
    y <- 1:length(im[1, , , 1])
    r2stl(x, y, z, filename = output, object.name = "raster2stl")
}


server(input, output)
# close from within R if possible:
Sys.sleep(2)
quit()
