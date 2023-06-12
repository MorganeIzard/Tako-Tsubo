#!/bin/bash
awk '$2 ~/^exm.*/' donnee.map > tempo.txt
awk '!($1="")' tempo.txt > temporary.txt
awk '!($2="")' temporary.txt > tempo.txt
awk '!($2="")' tempo.txt > temporary.txt
plink --file donnee --exclude temporary.txt --recode --out donnee
rm tempo.txt
rm temporary.txt
plink --file donnee --make-bed --out donnee
