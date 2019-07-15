# Geometric morphometrics and virtual biology in R (6-7 April 2019)

## April, 6th - Lesson 3

### Set working directory
getwd()
setwd("./day 1 data")
list.files()

### Import mesh and landmarks
library(Morpho)
mesh <- file2mesh("surfaces/endocast/Pan_cranium.ply", clean = F)
lm <- read.table("surfaces/endocast/Pan_lm.txt", header = F)
str(mesh)
class(mesh)
shade3d(mesh, col="grey")

### ---  WORKING WITH MESHES (Build endocasts) --- ###

### Spherical flipping
library(Arothron)

plotOrigin(100)
shade3d(mesh, col="grey")

sf <- spherical.flipping(C=c(0,0,0), mesh=mesh, param1=1, param2=5)
str(sf)
sf <- t(cbind(sf,1))

flip <- mesh
flip$vb <- sf

plotOrigin(100)
shade3d(mesh, col="grey")
shade3d(flip, col="grey")

### Extract external surface
ext <- ext.int.mesh(mesh = mesh, views=50, import_pov=NULL, matrix_pov=F, method = "c", param1 = 1, param2 = 100)
str(ext)
out <- out.inn.mesh(ext, mesh = mesh, plot = T)

### Endocast
inv <- out$invisible
shade3d(inv, col="grey")

lm <- as.matrix(lm)
shade3d(mesh, col="grey", alpha=.5)
spheres3d(lm, col="red", radius=2)

end <- ext.int.mesh(mesh = mesh, import_pov=T, matrix_pov=lm, method = "a", param1 = .5, param2 = 20, default = F)
str(end)
end.mesh <- out.inn.mesh(scans = end, mesh = mesh, plot = F)

shade3d(end.mesh$visible, col="red")
shade3d(end.mesh$invisible, col="grey", alpha=.5)

endocast <- vcgIsolated(end.mesh$visible)
shade3d(endocast, col="red")
shade3d(mesh, col="grey", alpha=.5)
