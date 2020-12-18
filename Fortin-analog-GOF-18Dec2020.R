
#setwd("your/working/directory/")
setwd("C:\\Users\\Dal User\\Desktop\\Fortin\\")

###########################################################################
### this script is to run goodness-of-fit and analogue analyses of KR02
### from Fortin et al. 2015 JOPL using Fortin et al. 2015 
### as training set data
## Fortin et al. 2015 full training set data (chironomid & environmental data)
## is available at Polar Data Catalogue www.polardata.ca CCIN Ref No. 12504.
# For simplicity, we have deleted site "E511" (outlier in Fortin et al. 2015)
# from the full chironomid training set (435 lakes). Such that "TS.csv",
# is 434 lakes; TS2.csv has chironomid data as % relative abundances

TS2<-read.csv(file="TS2.csv", row.names=1)
spp<-TS2[,-1]

# This core file is for Lake KR02 as presented in the Fortin et al. 2015 paper as an
# example of how to use the model and run performance statistics on a core

coreinput_analog<-read.csv(file="KR02.csv", row.names=1)

# this removes the age column

core_analog <- coreinput_analog[,-cbind(1:2)]

# Fortin et al. 2015 used filtered >=2%-in-2-lakes spp criteria in their analyses
# this code is to retain only taxa that are >=2% in 2 intervals in the training set
N <- 2
M <- 2
i <- colSums(spp >= M) >= N
spp_red <- spp[, i, drop = FALSE]
# 61 chironomid taxa remain in training set
ncol(spp_red)

#here I identify the columns that we keep based on our deletion criteria 
#this allows us to filter the core such that we only include taxa in the model
#the rest are deleted.

cols_to_keep <- intersect(colnames(spp_red),colnames(core_analog))

core_gof <- core_analog[,cols_to_keep, drop=FALSE]
ncol(core_gof)


# env2.csv has E511 removed (outlier in Fortin et al. 2015)
env2 <- read.csv(file="env2.csv", row.names=1)

# chronological axis for plotting analogue results
chron <- cbind(coreinput_analog[,1] , coreinput_analog[,2])
colnames(chron) <- c("Depth","Age")
chron=as.data.frame(chron)

require("ggpalaeo")
require("analogue")
require("ggplot2")

spp_T <- decostand(spp_red, method="hellinger")
core_T <- decostand(core_gof, method="hellinger")

#goodness-of-fit residuals
rlens <- residLen(spp_T, env2$July, core_T)
autoplot(rlens, df = data.frame(age = as.numeric(chron$Age)), x_axis = "age", fill = c("azure4", "grey","white")) +
  labs(x = "age", y = "Squared residual distance", fill = "Goodness of fit", categories = c("Good", "Fair", "Poor"))

#analogue distance
## squared chord lengths for Core 
AD <- analogue_distances(spp, core_analog)
autoplot(AD, df = data.frame(age = as.numeric(chron$Age)), x_axis = "age", fill = c("azure4", "grey","white")) +
  labs(x = "Year", y = "Squared-chord distance")

#Run Telford analysis
#Telford, R. J., & Birks, H. J. B. (2011). 
#A novel method for assessing the statistical significance of quantitative reconstructions 
#inferred from biotic assemblages. Quaternary Science Reviews, 30(9-10), 1272-1278.
library(palaeoSig)
require(rioja)

rlghr <- randomTF(spp = spp_T, env =  env2$July,
                  fos = core_T, n = 999, fun = WAPLS,  col = 2)
rlghr$sig
plot(rlghr, "Temp")

require("ggplot2")
autoplot(rlghr, "Temp")
#
#
######################################################
# analogue, passively plot core
#build core model using MAT
mod <- MAT(spp_T, env2$July)
autoplot(mod)

#timetrack supplemental

mod <- timetrack(spp, core_gof, transform = "hellinger",
                 method = "rda")

mod
plot(mod)
ordisurf(mod, env2$July, add=T, col="black", lwd=2)

#build the model
fit <- WAPLS(spp_T, env2$July, nlps=2)

fit
# cross-validate model
#rioja:::crossval(mod)
fit.cv <- rioja:::crossval(fit, cv.method="loo")
# How many components to use?
rand.t.test(fit.cv)
screeplot(fit.cv)

#predict the core
pred <- predict(fit, core_T, npls=2, sse=TRUE, nboot=1000)
Age<-chron$Age
plot(Age, pred$fit[,1], type="b", ylim=range(c(pred$fit[,1]-pred$v1.boot[,1], pred$fit[,1]+pred$v1.boot[,1])))
arrows(Age, pred$fit[,1]-pred$v1.boot[,1], Age, pred$fit[,1]+pred$v1.boot[,1], length=0.05, angle=90, code=3)




