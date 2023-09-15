#!/bin/bash
mkdir SexCheck
plink --bfile Tri_exm/donnee --sexcheck --out SexCheck/donnee_sc
grep "PROBLEM" SexCheck/donnee_sc.sexcheck > sc.txt
awk '!($3="")' sc.txt > tempo.txt
awk '!($3="")' tempo.txt > sc.txt
awk '!($3="")' sc.txt > tempo.txt
awk '!($3="")' tempo.txt > sc.txt
mv sc.txt /SexCheck
rm tempo.txt
plink --bfile Tri_exm/donnee --remove SexCheck/sc.txt --recode --out SexCheck/donnee_sc
plink --file SexCheck/donnee_sc --make-bed --out SexCheck/donnee_sc

