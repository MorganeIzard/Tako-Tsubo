#!/bin/bash
awk '$2 ~/^exm.*/' Initial/Tako_Data.map > tempo.txt
awk '!($1="")' tempo.txt > temporary.txt
awk '!($2="")' temporary.txt > tempo.txt
awk '!($2="")' tempo.txt > temporary.txt
mkdir Tri_exm
plink --file donnee --exclude temporary.txt --recode --out Tri_exm/donnee
rm tempo.txt
rm temporary.txt
plink --file Tri_exm/donnee --make-bed --out Tri_exm/donnee
