#!/bin/bash
mkdir MAF
plink --file IBD/donnee_IBD --maf 0.01 --make-bed --out MAF/donnee_m
mkdir MIND
plink --bfile MAF/donnee_m --mind 0.1 --make-bed --out MIND/donnee_mi
mkdir GENO 
plink --bfile MIND/donnee_mi --geno 0.01 --make-bed --out GENO/donnee_geno
mkdir HWE
plink --bfile GENO/donnee_geno --hwe 0.001 --recode --out HWE/donnee_hwe
