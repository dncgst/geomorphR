library(Arothron)
library(Morpho)
library(rgl)

setwd("day 2 data/")
getwd()

sets<-read.amira.dir("Lesson 4/set_pri/","auto")
patch<-read.amira.set("Lesson 5/Alo_car_patch.txt","auto")[,,1]
ref_sur<-file2mesh("Lesson 4/sur_pri/Alo_car_F.ply")

open3d()
wire3d(ref_sur,col="orange")
spheres3d(sets[,,1])
spheres3d(patch,col="violet")

?createAtlas
atlas<-createAtlas(ref_sur,sets[,,1],patch)
plotAtlas(atlas)

dimnames(sets)[[3]]<-substr(list.files("Lesson 4/sur_pri/"),1,9)
?placePatch
patches<-placePatch(atlas,sets,"Lesson 4/sur_pri")
dim(sets) #dimension of the array (landmark configurations only)
dim(patches) #landmark configurations + semi-landmarks
?slider3d()

fix<-1:61
surp<-62:76
slid<-slider3d(patches,SMvector = fix,surp=surp,
               sur.path="Lesson 4/sur_pri",fixRepro=FALSE,
               deselect=TRUE,iterations = 3)

newset<-slid$dataslide

gpa<-procSym(newset)
spec_names<-list.files("Lesson 4/set_pri")
otu<-substr(spec_names,1,7)
plot(gpa$PCscores[,1],gpa$PCscores[,2])
text(gpa$PCscores[,1],gpa$PCscores[,2],otu)

PCscores<-gpa$PCscores
PCs<-gpa$PCs
mshape<-gpa$mshape
fix(PC1_min)

PC1_max<-showPC(max(PCscores[,3]),PCs[,3],mshape)
PC1_min<-showPC(min(PCscores[,3]),PCs[,3],mshape)

deformGrid3d(PC1_min,PC1_max)
deformGrid3d(PC1_min[62:76,],PC1_max[62:76,],size = 0.005)

sur_patch <- file2mesh("Lesson 4/sur_pri/Alo_car_F.ply")

sur_vert <- vert2points(sur_patch)
head(sur_vert)

?kmeans
ev_spac <- kmeans(sur_vert, centers = 100)
str(ev_spac)
ev_spac_coo <- ev_spac$centers
plot(ev_spac$cluster)


### Curves

curv <- read.path.amira("Lesson 5/curves/Alo_car_F.txt")
str(curv)
ev_sp <- equidistantCurve(as.matrix(curv), 20)
spheres3d(ev_sp, col="green", radius = 1)
spheres3d(curv, col="black", radius = .1)




### Import curves
curves_a <- array(NA, dim=c(11,3,28))

for (i in 1:28) {
  path_in <- paste("Lesson 5/curves/",list.files("Lesson 5/curves/")[i],sep="")
  curv_i <- read.path.amira(path_in)
  curv_es_i <- equidistantCurve(as.matrix(curv_i),11)
  curves_a[,,i] <- curv_es_i
}


### Export to Amira
dir.create("curves_es")

array2list <- function(array) {
  lista <- list()
  for (i in 1:dim(array)[3]) {
    lista[[i]] <- array[,,1]
  }
  return(lista)
}

curves_list <- array2list(curves_a)
export_amira(curves_list,"curves_es")
