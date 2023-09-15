#!/bin/bash

sed -i "s/^\s*//g" TopSNP.txt

awk '!($3="")' TopSNP.txt > tempo.txt
awk '!($3="")' tempo.txt > tempo2.txt
awk '!($4="")' tempo2.txt > tempo.txt
awk '!($4="")' tempo.txt > tempo2.txt
awk '!($4="")' tempo2.txt > tempo.txt
awk '!($4="")' tempo.txt > tempo2.txt
awk '!($4="")' tempo2.txt > TopCleanSNP.txt
rm tempo*
sed -i "s/\s\+/\t/g" TopCleanSNP.txt
sed -i 's/[0-9]\+_\([0-9]*\)/\1/g' TopCleanSNP.txt 
sed -i "s/^/Rscript Manhattan.R\t/g" TopCleanSNP.txt 
sed -i "s/\(\([0-9]\+\)\t[0-9]\+.*\)/\1 only_snv_\2\.vcf\tVCF_donneesinitiales\/donnee_PO.bim/g" TopCleanSNP.txt 

bash TopCleanSNP.txt
