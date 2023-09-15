#!/bin/bash
FILE_DIR = Initial/Tako_Data
if test -f "${FILE_DIR}.ped"; then 
echo ${FILE_DIR}.ped
fi plink --bfile ${FILE_DIR} --recode --out ${FILE_DIR}

awk '$2 ~/^exm.*/' ${FILE_DIR}.map > tempo.txt
awk '!($1="")' tempo.txt > temporary.txt
awk '!($2="")' temporary.txt > tempo.txt
awk '!($2="")' tempo.txt > temporary.txt
mkdir Tri_exm
plink --file donnee --exclude temporary.txt --recode --out Tri_exm/donnee
rm tempo.txt
rm temporary.txt
plink --file Tri_exm/donnee --make-bed --out Tri_exm/donnee

mkdir SexCheck
plink --bfile Tri_exm/donnee --sexcheck --out SexCheck/donnee_sc
grep "PROBLEM" SexCheck/donnee_sc.sexcheck > sc.txt
awk '!($3="")' sc.txt > tempo.txt
awk '!($3="")' tempo.txt > sc.txt
awk '!($3="")' sc.txt > tempo.txt
awk '!($3="")' tempo.txt > sc.txt
mv sc.txt SexCheck/
rm tempo.txt
plink --bfile Tri_exm/donnee --remove SexCheck/sc.txt --recode --out SexCheck/donnee_sc
plink --file SexCheck/donnee_sc --make-bed --out SexCheck/donnee_sc

mkdir IBD
plink --file SexCheck/donnee_sc --genome
LC_NUMERIC=C awk '($10 > 0.125)' plink.genome > ibd.txt
sed '1d' ibd.txt > tmp.txt
awk '!($5="")' tmp.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
rm tempo.txt
rm tmp.txt
mv ibd.txt IBD/
mv plink.genome IBD/
