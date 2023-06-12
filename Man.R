library(qqman)
library(officer)
library("rtracklayer")
library("GenomicRanges")

download.file("https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz",destfile="./gencode.v19.annotation.gtf.gz")
system("gunzip --keep --force gencode.v19.annotation.gtf.gz")
Exons<-rtracklayer::readGFF("gencode.v19.annotation.gtf.gz")
Exons$seqid<-gsub("^chr","",Exons$seqid)


Genes<-Exons[Exons$type=="gene",]
Genes<-Genes[Genes$gene_type=="protein_coding",]
Genes.GR<-makeGRangesFromDataFrame(Genes,keep.extra.columns=TRUE)

model <- read.table("LAST.model", header = TRUE )
donnee <- read.table("LAST.assoc.fisher", header = TRUE )
mod <- merge(model, subset(donnee, select = c("SNP", "BP")), all.x = TRUE)

man <- function(data){
  all <- data[data$TEST == "ALLELIC",]
  dom <- data[data$TEST == "DOM",]
  rec <- data[data$TEST == "REC",]
  geno <- data[data$TEST == "GENO",]
  
  pdf("Manhattan_OUT_1.pdf", width=29.7/2,height=21/2)
  manhattan(all, main = "Allelic")
  qq(all$P)
  dev.off()
  pdf("Manhattan_OUT_2.pdf", width=29.7/2,height=21/2)
  manhattan(dom, main = "Dominant")
  qq(dom$P)
  dev.off()
  pdf("Manhattan_OUT_3.pdf", width=29.7/2,height=21/2)
  manhattan(rec, main = "Recessive")
  qq(rec$P)
  dev.off()
  pdf("Manhattan_OUT_4.pdf", width=29.7/2,height=21/2)
  manhattan(geno, main = "Genomic ")
  qq(geno$P)
  dev.off()
}

man(mod)

all <- mod[mod$TEST == "ALLELIC",]
dom <- mod[mod$TEST == "DOM",]
rec <- mod[mod$TEST == "REC",]
geno <- mod[mod$TEST == "GENO",]
top_all <- all[all$P <=1e-05,]
top_dom <- dom[dom$P <=1e-05,]
top_rec <- rec[rec$P <=1e-05,]
top_geno <- geno[geno$P <=1e-05,]

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
  pdf(paste0(dt[dt$SNP == snp,]$TEST, "_", snp, "_Manhattan_Plot_",".pdf"))
  plot(-log10(smol_dt$P) ~ smol_dt$BP, xlab = "BP", 
       ylab = "-log10(p)", pch = 19, col = smol_dt$col, 
       main = "Manhattan plot",ylim = c(-5,10))
  text(signal$BP, -log10(signal$P)+0.5, signal$SNP)
  abline(h = -log10(8e-08), col = 'red')
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
for (snp in top_geno$SNP){
  plot_graph(geno, snp, 1000000)
}
