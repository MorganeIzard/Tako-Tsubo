setwd("/home/u1166/Documents/GWAS")
library(qqman)
library(officer)
simple <- read.table("covSPPP.assoc.logistic", header = TRUE)
dom <- read.table("covSPPP_D.assoc.logistic", header = TRUE)
rec <- read.table("covSPPP_R.assoc.logistic", header = TRUE)

add_sim <- simple[simple$TEST == "ADD",]
add_sim <- na.omit(add_sim)
add_dom <- dom[dom$TEST == "DOM",]
add_dom <- na.omit(add_dom)
add_rec <- rec[rec$TEST == "REC",]
add_rec <- na.omit(add_rec)
top_all <- add_sim[add_sim$P <=1e-05,]
top_dom <- add_dom[add_dom$P <=1e-05,]
top_rec <- add_rec[add_rec$P <=1e-05,]

pdf("Manhattan_post_out_Cov_all.pdf", width=29.7/2,height=21/2)
manhattan(add_sim, ylim = c(0,10), annotatePval = 1e-05, main = "Allelic")
qq(add_sim$P)
dev.off()
pdf("Manhattan_post_out_Cov_dom.pdf", width=29.7/2,height=21/2)
manhattan(add_dom, ylim = c(0,10), annotatePval = 1e-05, main = "Dominant")
qq(add_dom$P)
dev.off()
pdf("Manhattan_post_out_Cov_rec.pdf", width=29.7/2,height=21/2)
manhattan(add_rec, ylim = c(0,10), annotatePval = 1e-05, main = "Recessive")
qq(add_rec$P)
dev.off()


plot_graph <- function(dt, snp, cadre){   #dt = data.frame, snp = chr
  signal <- dt[dt$SNP == snp,]
  chr <- dt[dt$CHR == signal$CHR,]
  bp <- dt[dt$SNP == snp,]$BP
  smol_dt <- chr[(chr$BP >= bp-(cadre/2) & chr$BP <= bp+(cadre/2)),]
  Region.GR<-makeGRangesFromDataFrame(
    data.frame(
      seqnames=signal$CHR,
      start=bp-(cadre/2),
      end=bp+(cadre/2)))
  GenesInRegion.GR<-Genes.GR[
    to(
      findOverlaps(
        Region.GR,
        Genes.GR,
        ignore.strand=TRUE)
    )
  ]
  
  GenesInRegion.GR.FWD<-GenesInRegion.GR[strand(GenesInRegion.GR)=="+"]
  GenesInRegion.GR.REV<-GenesInRegion.GR[strand(GenesInRegion.GR)=="-"]
  
  smol_dt$col <- c("gray37")
  smol_dt[smol_dt$SNP == snp, "col" ] <- "red"
  #mat <- as.matrix(data.frame(AFF = c(signal$F_A, 1-signal$F_A),
  #                            UNAFF = c(signal$F_U, 1-signal$F_U)))
  #rownames(mat) <- c("A1", "A2")
  
  ##### Manhattan #####
  pdf(paste0(dt[dt$SNP == snp,]$TEST, "_", snp, "_Manhattan_Plot_",".pdf"), width=29.7/2,height=21/2)
  plot(-log10(smol_dt$P) ~ smol_dt$BP, xlab = "BP", 
       ylab = "-log10(p)", pch = 19, col = smol_dt$col, 
       main = "Manhattan plot",ylim = c(-5,10))
  text(signal$BP, -log10(signal$P)+0.5, signal$SNP)
  abline(h = -log10(5e-08), col = 'red')
  abline(h = -log10(1e-05), col = 'blue')
  if(length(GenesInRegion.GR.FWD)>0){
    rect(
      xleft=start(GenesInRegion.GR.FWD),
      ybottom=-2,
      xright=end(GenesInRegion.GR.FWD),
      ytop=-1,
      col = "indianred1")
    text(
      x=start(GenesInRegion.GR.FWD)+(end(GenesInRegion.GR.FWD)-start(GenesInRegion.GR.FWD))/2,
      y=-2,
      lab=GenesInRegion.GR.FWD$gene_name,
      pos=3,srt = 90)
  }
  if(length(GenesInRegion.GR.REV)>0){
    rect(
      xleft=start(GenesInRegion.GR.REV),
      ybottom=-4,
      xright=end(GenesInRegion.GR.REV),
      ytop=-3,
      col = "indianred1")
    text(
      x=start(GenesInRegion.GR.REV)+(end(GenesInRegion.GR.REV)-start(GenesInRegion.GR.REV))/2,
      y=-4,
      lab=GenesInRegion.GR.REV$gene_name,
      pos=3,
      srt = 90)
  }
  dev.off()
  return()
} 


for (snp in top_all$SNP){
  plot_graph(all, snp, 1000000)
}
for (snp in top_dom$SNP){
  plot_graph(dom, snp, 1000000)
}
for (snp in top_rec$SNP){
  plot_graph(rec, snp, 1000000)
}

top_all$AFF = NULL
top_all$UNAFF = NULL
top_dom$AFF = NULL
top_dom$UNAFF = NULL
top_rec$AFF = NULL
top_rec$UNAFF = NULL

# top <- top_dom
# top <- rbind(top, top_dom)
# top <- rbind(top, top_rec)
# top <- top[!duplicated(top$SNP),]