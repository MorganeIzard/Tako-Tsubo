library(ggplot2)
library(ggside)
pc <- read.table("pca_d.eigenvec")
info <- read.table("donnee_out.fam")



colnames(pc) <- c("FID", "IID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9",
                  "PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17",
                  "PC18","PC19","PC20")
colnames(info) <- c("FID", "IID", "PID", "MID", "SEX", "PHENO")

merg <- merge(pc,subset(info, select = c("IID", "SEX", "PHENO")), all.x = TRUE)

merg$colsex <- "firebrick"
merg[merg$SEX == 1, "colsex" ] <- "steelblue"
merg$colpheno <- "firebrick"
merg[merg$PHENO == 1, "colpheno" ] <- "forestgreen"
merg$sex <- "Female"
merg[merg$SEX == 1, "sex" ] <- "Male"
merg$state <- "Affected"
merg[merg$PHENO == 1, "state" ] <- "Unaffected"


pdf("PCA_cohorte.pdf")
plot(merg$PC1,merg$PC2, col = merg$colpheno, pch = 19, xlab = "PC1", ylab = "PC2", main = "ACP cohorte")
legend(-0.15, -0.10, legend = c("Affected", "Unaffected"), 
       col= c("firebrick", "forestgreen"),
       pch = 19)
abline(h = 0.0686803, v = -0.0196231, col = "blue")
dev.off()

identify(merg$PC1,merg$PC2,labels = rownames(merg))


smol1 <- merg[merg$PC1 <= -0.0196231,]
smol2 <- merg[merg$PC2>= 0.0686803,] 
write.table(subset(smol1, select = c("IID", "FID")), "outlierPC1.txt")
write.table(subset(smol2, select = c("IID", "FID")), "outlierPC2.txt")

