library(data.table)

tako <- fread("TAKOGENE_ANSI_20180711.csv")
pc <- read.table("pca_OUT.eigenvec")
colnames(pc) <- c("FID", "IID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9",
                  "PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17",
                  "PC18","PC19","PC20")
cv <- merge(pc, tako, by.x = "IID", by.y = "SUBJECT_REF")

cv$IMC <- as.numeric(cv$V_POIDS)/(as.numeric(cv$V_TAILLE)*0.01)**2
cv$SEXE <- 2
cv[cv$I_SEXE == "Masculin", "SEXE" ] <- 1
write.table(cv, file = "covar.txt", row.names=FALSE)

num <- subset(cv, select = c("FID", "IID", "SEXE", "I_BIRTHDATE_Y", "V_TAILLE", "V_SYTOLIQUE", "V_DIASTOLIQUE", "V_FREQCARD", "V_ECHOFEVG", "V_GRADMAX",
                               "V_ECHOFEVGSORTI", "V_GRADMAX2", "V_VENTRFEVG", "V_VENTRFEVD", "V_IRMFEVG", "V_DEGSTENOSETCG_L1",
                               "V_DEGSTENOSETCG_L2","V_DEGSTENOSETCG_L3","V_DEGSTENOSETCG_L4","V_DEGSTENOSETCG_L5","V_DEGSTENOSETCG_L6",
                               "V_DEGSTENOSETCG_L7","V_POIDS", "V_BIOTROPOUSRESULT", "V_BIOTROPOUSSEUIL", "V_BIOCPKRESULT", "V_BIOCPKSEUIL", 
                               "V_BIOBNPRESULT","V_BIOBNPSEUIL", "V_BIONTBNPRESULT", "V_BIONTBNPSEUIL", "IMC", "PC1",
                               "PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15",
                               "PC16","PC17", "PC18","PC19","PC20", "I1_GRPATIENT" ))
write.table(num, file= "covarnum.txt", row.names = FALSE)

smol <- subset(cv, select = c("FID","IID", "SEXE", "PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9",
                                                            "PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17",
                                                            "PC18","PC19","PC20", "I1_GRPATIENT"))
write.table(smol, file= "covarsmol.txt", row.names = FALSE)
