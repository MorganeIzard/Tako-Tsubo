args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("No arguments passed", call.=FALSE)
} else if(length(args)!=5) {
  stop("Not enough arguments, you need : Chromosome, Position(bp), Model, Fichier de référence pour les SNPs, Fichier bim de la cohorte",
       call.=FALSE)
}

setwd("~/Documents/impute5_v1.1.5/impute5_v1.1.5")
library("GenomicRanges")
library("rtracklayer")
library("data.table")

Mini_man <- function(dt, bp, snp, cadre, ld){
  bp <- as.numeric(bp)
  signal <- dt[dt$BP == bp,]
  smol <- dt[(dt$BP >= bp-(cadre/2) & dt$BP <= bp+(cadre/2)),]
  smol_geno <-smol[smol$type == "genotype",]
  smol_impu <-smol[smol$type == "impute",]
  ld$P <- as.numeric(ld$P)
  
  Region.GR<-makeGRangesFromDataFrame(
    data.frame(
      seqnames=dt[1, "CHR"],
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
  EnhancerInRegion.GR<-Enhancer.GR[
    to(
      findOverlaps(
        Region.GR,
        Enhancer.GR,
        ignore.strand=TRUE)
    )
  ]
  PromoterInRegion.GR<-Promoter.GR[
    to(
      findOverlaps(
        Region.GR,
        Promoter.GR,
        ignore.strand=TRUE)
    )
  ]
  
  GenesInRegion.GR.FWD<-GenesInRegion.GR[strand(GenesInRegion.GR)=="+"]
  GenesInRegion.GR.REV<-GenesInRegion.GR[strand(GenesInRegion.GR)=="-"]
  
  ##### Manhattan #####
  #print(signal)
  pdf(paste0(signal$TEST, "_", snp, "_Manhattan_Plot",".pdf"))
  #graph <- rvg::dml(code = {

  plot(-log10(smol_impu$P) ~ smol_impu$BP, xlab = "BP",
       ylab = "-log10(p)", pch = smol_impu$point, col = smol_impu$col,
       main = paste0("Manhattan plot ", snp, " chr ", chr),ylim = c(-10,10), xlim = c(bp-(cadre/2),bp+(cadre/2)))
  points(-log10(smol_geno$P) ~ smol_geno$BP, pch = smol_geno$point, col = smol_geno$col)
  points(-log10(ld$P) ~ ld$POS, pch = 16, col = "forestgreen")
  points(-log10(signal$P) ~ signal$BP, pch = signal$point, col = signal$col)
  abline(h = -log10(8e-08), col = 'red')
  abline(h = -log10(1e-05), col = 'blue')
  abline(h = -5.5)
  abline(h = -7.5)  
  par(xpd = TRUE)
  text((bp - cadre/2)-45000,-6.5, "(Left Ventricul)", adj=1, cex = 0.7)
  text((bp - cadre/2)-45000, -5.5, "Enhancer", adj = 1)
  text((bp - cadre/2)-45000, -7.5, "Promoter", adj = 1)
  if(length(ld$POS) == 0){
    legend("topleft", legend = c(snp, "Cohorte", "Imputé"), pch = c(8, 16, 16, 16), 
           col = c("red", "lightgray", "gray40") , cex = 0.9, bg = "white")
  } else {
    legend("topleft", legend = c(snp, "LD > 0.7", "Cohorte", "Imputé"), pch = c(8, 16, 16, 16), 
         col = c("red", "forestgreen", "lightgray", "gray40") , cex = 0.9, bg = "white")
  }
  
  legend("topright", title = "Expression LV (en TPM)", legend = c("0", "0<, >1", "1<, >100", "100<"), pch = 15, 
         col = c("lightpink", "plum", "paleturquoise", "palegreen"), cex = 0.9, bg = "white")
  
  if(length(GenesInRegion.GR.FWD)>0){
    GenesInRegion.GR.FWD$col <- "lightpink"
    for (name in GenesInRegion.GR.FWD$gene_name){
      if(name %in% Nvx_Expre$Description){
        if(Nvx_Expre[Nvx_Expre$Description == name,]$group_sum > 0 & Nvx_Expre[Nvx_Expre$Description == name,]$group_sum < 1){
          GenesInRegion.GR.FWD[GenesInRegion.GR.FWD$gene_name == name,]$col <- "plum"
        }
        else if(Nvx_Expre[Nvx_Expre$Description == name,]$group_sum >= 1 & Nvx_Expre[Nvx_Expre$Description == name,]$group_sum < 100){
          GenesInRegion.GR.FWD[GenesInRegion.GR.FWD$gene_name == name,]$col <- "paleturquoise"
        }
        else if(Nvx_Expre[Nvx_Expre$Description == name,]$group_sum >= 100){
          GenesInRegion.GR.FWD[GenesInRegion.GR.FWD$gene_name == name,]$col <- "palegreen2"
        }
      }
    }
    rect(
      xleft=start(GenesInRegion.GR.FWD),
      ybottom=-2,
      xright=end(GenesInRegion.GR.FWD),
      ytop=-1,
      col = GenesInRegion.GR.FWD$col)
    text(
      x=start(GenesInRegion.GR.FWD)+(end(GenesInRegion.GR.FWD)-start(GenesInRegion.GR.FWD))/2,
      y=-1.5,
      lab=GenesInRegion.GR.FWD$gene_name,
      cex = 0.8)
  }
  if(length(GenesInRegion.GR.REV)>0){
    GenesInRegion.GR.REV$col <- "lightpink"
    for (name in GenesInRegion.GR.REV$gene_name){
      if(name %in% Nvx_Expre$Description){
        if(Nvx_Expre[Nvx_Expre$Description == name,]$group_sum > 0 & Nvx_Expre[Nvx_Expre$Description == name,]$group_sum < 1){
          GenesInRegion.GR.REV[GenesInRegion.GR.REV$gene_name == name,]$col <- "plum"
        }
        else if(Nvx_Expre[Nvx_Expre$Description == name,]$group_sum >= 1 & Nvx_Expre[Nvx_Expre$Description == name,]$group_sum < 100){
          GenesInRegion.GR.REV[GenesInRegion.GR.REV$gene_name == name,]$col <- "paleturquoise"
        }
        else if(Nvx_Expre[Nvx_Expre$Description == name,]$group_sum >= 100){
          GenesInRegion.GR.REV[GenesInRegion.GR.REV$gene_name == name,]$col <- "palegreen2"
        }
      }
    }
    rect(
      xleft=start(GenesInRegion.GR.REV),
      ybottom=-4,
      xright=end(GenesInRegion.GR.REV),
      ytop=-3,
      col = GenesInRegion.GR.REV$col)
    text(
      x=start(GenesInRegion.GR.REV)+(end(GenesInRegion.GR.REV)-start(GenesInRegion.GR.REV))/2,
      y=-3.5,
      lab=GenesInRegion.GR.REV$gene_name,
      cex = 0.8)
  }
  if(length(EnhancerInRegion.GR)>0){
    rect(
      xleft=start(EnhancerInRegion.GR),
      ybottom=-6,
      xright=end(EnhancerInRegion.GR),
      ytop=-5,
      col = "indianred1")
  }
  
  if(length(PromoterInRegion.GR)>0){
    rect(
      xleft=start(PromoterInRegion.GR),
      ybottom=-8,
      xright=end(PromoterInRegion.GR),
      ytop=-7,
      col = "indianred1")
  }
  dev.off()
}

#download.file("https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz",destfile="./gencode.v19.annotation.gtf.gz")
#system("gunzip --keep --force gencode.v19.annotation.gtf.gz")
Exons<-rtracklayer::readGFF("gencode.v19.annotation.gtf")
Exons$seqid<-gsub("^chr","",Exons$seqid)

Genes<-Exons[Exons$type=="gene",]
Genes<-Genes[Genes$gene_type=="protein_coding",]
Genes.GR<-makeGRangesFromDataFrame(Genes,keep.extra.columns=TRUE)

Enhancer.GR <- readRDS("~/Documents/Tako-Tsubo/PROMOTEUR_ENHANCER/Enhancer.GR.Rds")
Promoter.GR <- readRDS("~/Documents/Tako-Tsubo/PROMOTEUR_ENHANCER/Promoter.GR.Rds")

seqlevelsStyle(Enhancer.GR) <- "NCBI"
seqlevelsStyle(Promoter.GR) <- "NCBI"

Nvx_Expre <- read.table("/home/u1166/Documents/Tako-Tsubo/GTEX/Avg.Rlong.tsv", header = TRUE)

chr <- args[1]
pos <- args[2]
model <- args[3]
snv_ref <- args[4]
snp_cohorte <- args[5]

data <- read.table(paste0("Model/Tako",chr,"new.tri.model"), header=TRUE)
subdata <- data[data$TEST == model, ]
subdata <- subdata[!is.na(subdata$P),]
tmp <- unlist(strsplit(subdata$SNP, "_"))
tmp <- tmp[c(FALSE, TRUE)]
subdata$BP <- tmp
subdata <- subdata[, -2]
subdata$BP <- as.numeric(subdata$BP)


ref <- fread(snv_ref)
if(!pos %in% ref$POS){
  stop("Pas de concordance avec le fichier common", call.=FALSE)
}
snp <- ref[POS == pos]$ID
print(snp)

genotypage <- read.table(snp_cohorte)
colnames(genotypage) <- c("CHR", "SNP", "cM", "BP", "A1", "A2")
geno <- genotypage[genotypage$CHR == chr,]

subdata$col <- "lightgray"
subdata$type <- "genotype"
subdata[!subdata$BP %in% geno$BP,"col"] <- "gray40"
subdata[!subdata$BP %in% geno$BP,"type"] <- "impute"
subdata[subdata$BP == pos,"col"] <- "red"
subdata$point <- 16
if(!pos %in% geno$BP){
  subdata[subdata$BP == pos,"point"] <- 8
}

cadre <- 1000000

ld <- read.table("~/Documents/Tako-Tsubo/LD/ALL_SIGNALS.LD.txt")
colnames(ld) <- c("CHR1", "POS1", "CHR2", "POS2", "N_CHR", "R2")
if(pos %in% ld$POS1){
  ldTOP <- ld[ld$POS1 == pos, ]
  ldUP <- ldTOP[ldTOP$R2 >= 0.7, ]
  ldALL <- merge(ldUP, subset(subdata, select = c("BP", "P")), by.x = "POS2", by.y = "BP", all.x = TRUE)
  ldALL$POS <- ldALL$POS2
}
if(pos %in% ld$POS2){
  ldTOP <- ld[ld$POS2 == pos, ]
  ldUP <- ldTOP[ldTOP$R2 >= 0.7, ]
  ldALL <- merge(ldUP, subset(subdata, select = c("BP", "P")), by.x = "POS1", by.y = "BP", all.x = TRUE)
  ldALL$POS <- ldALL$POS1
}



Mini_man(subdata, pos, snp, cadre, ldALL)


if(interactive()){
  chr <- 16
  pos <- 6075047
  model <- "ALLELIC"

  data <- read.table(paste0("Model/Tako",chr,"new.tri.model"), header=TRUE)
  subdata <- data[data$TEST == model, ]
  subdata <- subdata[!is.na(subdata$P),]
  tmp <- unlist(strsplit(subdata$SNP, "_"))
  tmp <- tmp[c(FALSE, TRUE)]
  subdata$BP <- tmp
  subdata <- subdata[, -2]
  subdata$BP <- as.numeric(subdata$BP)


  ref <- fread(paste0("only_snv_", chr, ".vcf"))
  ref_cut <- ref[`#CHROM` == chr]
  snp <- ref_cut[POS == pos]$ID

  genotypage <- read.table("VCF_donneesinitiales/donnee_PO.bim")
  colnames(genotypage) <- c("CHR", "SNP", "cM", "A1", "A2")
  
  ld <- read.table(paste0("chr", chr, ".LD"), header = TRUE)
  ldTOP <- ld[ld$POS1 == pos, ]
  ldUP <- ldTOP[ldTOP$R.2 >= 0.7, ]
  ldUP$X <- -0.5

  dt <- subdata
  bp <- pos
  genotype <- genotypage
  cadre <- 1000000

  Mini_man <- function(dt, bp, snp, cadre, genotype, ldUP){
    signal <- dt[dt$BP == bp,]
    chr <- dt[dt$CHR == signal$CHR,]
    dt$col <- "gray44"
    dt[dt$BP == bp,"col"] <- "red"
    dt$point <- 16
    if(!(signal$BP %in% genotype$BP)){
      dt[dt$BP == bp,"point"] <- 17
    }
    smol <- dt[(dt$BP >= bp-(cadre/2) & dt$BP <= bp+(cadre/2)),]

    Region.GR<-makeGRangesFromDataFrame(
      data.frame(
        seqnames=data[1, "CHR"],
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

    ##### Manhattan #####
    print(signal)
    pdf(paste0(signal$TEST, "_", signal$SNP, "_Manhattan_Plot",".pdf"))
    #graph <- rvg::dml(code = {

    plot(-log10(smol$P) ~ smol$BP, xlab = "BP",
         ylab = "-log10(p)", pch = smol$point, col = smol$col,
         main = paste0("Manhattan plot ", signal$SNP),ylim = c(-5,10))
    text(signal$BP, -log10(signal$P)+0.5, snp)
    points(ldUP$P ~ ldUP$POS2, pch = 19, col = "forestgreen")
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
        pos=3)
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
        pos=3)
    }
    dev.off()
  }
}
  