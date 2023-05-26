library(data.table)
library(qqman)
library(officer)
library(ggplot2)
data <- read.table("covarnum.txt", header = TRUE)
data$col <- "red"
data[data$I1_GRPATIENT == "SCA","col"] <- "green4"
liste <- colnames(data)
liste <- liste[-c(1, 2, 33, 53, 54)]
pdf("ScatterPlot.pdf")
for (i in liste){
  tempdata <- data[,c("PC1", i)]
  colnames(tempdata) <- c("PC1", "y")
  g <- ggplot(data = tempdata, aes(x = PC1, y = y))+
    geom_point(col = data$col)+
    ggtitle(paste("Scatter Plot"))+
    xlab("PC1")+
      ylab(i)
  print(g)
}
dev.off()
