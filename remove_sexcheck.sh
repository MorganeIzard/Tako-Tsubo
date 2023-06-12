#!/bin/bash
plink --file donnee --check-sex
grep "PROBLEM" plink.sexcheck > sc.txt
awk '!($3="")' sc.txt > tempo.txt
awk '!($3="")' tempo.txt > sc.txt
awk '!($3="")' sc.txt > tempo.txt
awk '!($3="")' tempo.txt > sc.txt
rm tempo.txt
plink --bfile donnee --remove sc.txt --recode --out donnee_sc
plink --file donnee_sc --make-bed --out donnee_sc
