# Geometric morphometrics and virtual biology in R (6-7 April 2019)

## April, 6th - Lesson 1

### Set working directory
getwd()
setwd("./day 1 data")
list.files()

### --- READING, PLOTTING AND EXPORTING MESHES --- ###

### Import mesh
library(Morpho)
mesh <- file2mesh("surfaces/femur/femur_Pan_left.ply", clean = F)
str(mesh)
class(mesh)

### Extract vertices
vert <- vert2points(mesh)

### Build mesh froom vertices? Check Rvcg (Meshlab) package!

### Visualize mesh
library(rgl)
rgl::shade3d(mesh, color="grey", specular="black")
#### Embed parameters
?rgl.material
mesh$material <- list(color="grey", specular="black")
shade3d(mesh)

rgl::wire3d(mesh)

rgl::dot3d(mesh)

rgl::mfrow3d(1,3, sharedMouse = T)
shade3d(mesh) ;next3d()
wire3d(mesh) ;next3d()
dot3d(mesh)

### Export mesh
mesh2ply(mesh, "WS_femur.ply")

### --- READING, PLOTTING AND EXTRACTING DICON (CT scan) FILES --- ###

### Reading dicon files
library(oro.dicom)
dcm <- readDICOM("surfaces/legCT/", verbose = T, skipSequence = T)
class(dcm)
str(dcm$hdr[[1]])

### 
which(dcm$hdr[[1]]$name=="PixelSpacing")
which(dcm$hdr[[1]]$name=="SpacingBetweenSlices")
dcm$hdr[[1]]$value[c(73,41)]

voxelsize <- c(0.399,0.399,0.574994)
vol <- create3D(dcm)
str(vol)
dim(vol)

### Visualise slices
image(vol[,,256], col=grey(0:32/32),asp=1)
image(vol[,154,], col=grey(0:32/32),asp=1)
image(vol[116,,], col=grey(0:32/32),asp=1)

### Automatic segmentation
dens <- density(vol)
plot(dens)
denslog <- density(log(vol), na.rm = T)
plot(denslog)
exp(6)
#### on threshold base...
thr <- vol
thr[vol<exp(6)] = 0
thr[vol>=exp(6)] = 1
image(vol[116,,], col=grey(0:32/32),asp=1)
image(thr[116,,], col=grey(0:32/32),asp=1)

### 
library(Rvcg)
surf <- vcgIsosurface(vol=thr, threshold=1, spacing=voxelsize)
shade3d(surf)

### Isolate the elements
?vcgIsolated
bones <- vcgIsolated(mesh=surf, keep=4, split=T)
str(bones)
shade3d(bones[[1]])
shade3d(bones[[2]])
shade3d(bones[[3]])
shade3d(bones[[4]])

femur <- vcgIsolated(surf, facenum=NULL, diameter=NULL)
shade3d(femur)
