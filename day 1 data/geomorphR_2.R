# Geometric morphometrics and virtual biology in R (6-7 April 2019)

## April, 6th - Lesson 2

### Set working directory
getwd()
setwd("./day 1 data")
list.files()

### Import mesh
library(Morpho)
mesh <- file2mesh("surfaces/femur/femur_Pan_left.ply", clean = F)
str(mesh)
class(mesh)

### --- WORKING WITH MESHES (Transformation)--- ###

### Function: Plot origin
plotOrigin = function(L) {
  o=c(0,0,0)
  x=c(L,0,0)
  y=c(0,L,0)
  z=c(0,0,L)
  origin=rbind(o,x,y,z)
  
  spheres3d(o,col="black",radius=6)
  lines3d(origin[c(1,2),], col="red",lwd=3)
  lines3d(origin[c(1,3),], col="blue",lwd=3)
  lines3d(origin[c(1,4),], col="green",lwd=3)
}
plotOrigin(100)

### Translation
plotOrigin(200)
shade3d(mesh)

transl <- translate3d(mesh, x=100,y=100,z=0)
shade3d(mesh)
shade3d(transl, col="red")

### Scaling
scaled <- scale3d(mesh, x=2, y=2, z=2)
shade3d(mesh, alpha=.5)
shade3d(scaled, col="red", alpha=.5)

### Rotation
rot <- rotate3d(mesh, angle=pi/2, x=1, y=0, z=0) # rotate 90 degree around the x axis
shade3d(mesh)
shade3d(rot, col="red")

### --- WORKING WITH MESHES (Landmarks, allignment and planes)--- ###

###
femur <- file2mesh("surfaces/femur/femur_Pan_left.ply", clean = F)
lm1 <- read.table("surfaces/femur/LM_Pan_left.txt", header = F)
lm2 <- read.table("surfaces/femur/LM_Pan_left_transformed.txt", header = F)
str(femur)
str(lm1)
str(lm2)

lm1 <- as.matrix(lm1)
lm2 <- as.matrix(lm2)

shade3d(femur, col="grey")
spheres3d(lm1, radius = 3, col="red")
spheres3d(lm2, radius = 3, col="blue")

### Transform ()
rotated <- rotmesh.onto(femur, refmat=lm1, tarmat=lm2)
str(rotated)

shade3d(femur, col="grey")
spheres3d(lm1, radius = 3, col="red")
spheres3d(lm2, radius = 3, col="blue")
shade3d(rotated$mesh, col="cyan")

### Reflection
femurrx <- mirror(femur, pcAlign=F)
shade3d(femur, col="grey")
shade3d(femurrx, col="red")

### Plane through 3 points
mesh <- file2mesh("surfaces/hgeorgicus/hgeorgicus.ply", clean = F)
lm <- read.table("surfaces/hgeorgicus/lm_georgicus.txt", header = F)

shade3d(mesh, col="grey", alpha=.5)
spheres3d(lm, radius = 3, col="red", alpha=.5)
text3d(lm, text=1:21, cex=2)

plane <- lm[c(1,5,7),] # select the 3 points where the plane will pass
plane <- as.matrix(plane)

cut1 <- cutMeshPlane(mesh, v1=plane[1,], v2=plane[2,], v3=plane[3,])
cut2 <- cutMeshPlane(mesh, v1=plane[1,], v2=plane[2,], v3=plane[3,], keep.upper = F)
shade3d(cut1, col="blue")
shade3d(cut2, col="red")

### Outline of the mesh from plane
inter <- meshPlaneIntersect(mesh, v1=plane[1,], v2=plane[2,], v3=plane[3,])
shade3d(mesh, col="grey")
points3d(inter, col="red")

### --- WORKING WITH MESHES (Filtering)--- ###

### Decimating
str(mesh)
dec1 <- vcgQEdecim(mesh, percent = .5, topo = T)

object.size(mesh)
object.size(dec1)
meshres(mesh)
meshres(dec1)

mfrow3d(1,2, sharedMouse = T)
wire3d(mesh); next3d()
wire3d(dec1)


### Smoothing
smo1 <- vcgSmooth(mesh, type = "laplace", iteration = 10)
smo2 <- vcgSmooth(mesh, type = "laplace", iteration = 30)
smo3 <- vcgSmooth(mesh, type = "laplace", iteration = 50)

smo1 <- vcgSmooth(mesh, type = "taubin", iteration = 10, lambda = .3)
smo2 <- vcgSmooth(mesh, type = "taubin", iteration = 10, lambda = .5)
smo3 <- vcgSmooth(mesh, type = "taubin", iteration = 10, lambda = .7)

mfrow3d(2,2, sharedMouse = T)
shade3d(mesh, col="grey"); next3d()
shade3d(smo1, col="grey"); next3d()
shade3d(smo2, col="grey"); next3d()
shade3d(smo3, col="grey")
