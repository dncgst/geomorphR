# Geometric morphometrics and virtual biology in R (6-7 April 2019)

## April, 6th - Lesson 3

### Set working directory
getwd()
setwd("./day 1 data")
list.files()

### Import mesh
library(Morpho)
mesh <- file2mesh("surfaces/hgeorgicus/hgeorgicus.ply", clean = F)
str(mesh)
class(mesh)
shade3d(mesh, col="grey")

### ---  WORKING WITH MESHES (Curvatures, distances, surface area) --- ###

### Calculate mesh curvatures

curv <- vcgCurve(mesh)
str(curv)

curv.m <- curv$meanvb
summary(curv.m)
dens <- density(curv.m)
plot(dens)

curv.g <- curv$gaussvb
summary(curv.g)
dens <- density(curv.g)
plot(dens)

meshDist(mesh, distvec=curv.m, from=-1 , to=1)
meshDist(mesh, distvec=curv.s, from=-1 , to=1)

### Calculate mesh distances
rx <- ply2mesh("surfaces/femur/femur_Pan_right.ply")
lx <- ply2mesh("surfaces/femur/femur_Pan_left.ply")
lm.r <- read.table("surfaces/femur/LM_Pan_right.txt", header = F)
lm.l <- read.table("surfaces/femur/LM_Pan_left.txt", header = F)

shade3d(rx, col="grey")
shade3d(lx, col="cyan")
spheres3d(lm.r, col="red", radius=2)
spheres3d(lm.l, col="blue", radius=2)

rx.rot <- rotmesh.onto(rx, refmat=as.matrix(lm.r), tarmat = as.matrix(lm.l), reflection = T)
shade3d(rx.rot$mesh, col="grey")

rx.rot <- rotmesh.onto(rx, refmat=as.matrix(lm.r), tarmat = as.matrix(lm.l), reflection = T, adnormals = T)
shade3d(rx.rot$mesh, col="grey")

rx.rot.s <- rotmesh.onto(rx, refmat=as.matrix(lm.r), tarmat = as.matrix(lm.l), reflection = T, adnormals = T, scale = T)

shade3d(lx, col="grey")
shade3d(rx.rot.s$mesh, col="red")

md <- meshDist(lx, rx.rot.s$mesh, from = -1, to = 1)


### Calculate surface area



