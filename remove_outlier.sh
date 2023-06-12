#!/bin/bash
plink --file donnee_m --remove outlier.txt --recode --out donnee_out
plink --file donnee_out --make-bed --out donnee_out
plink --file donnee_out --pca var-wts --out pca_d
