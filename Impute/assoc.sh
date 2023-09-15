#!/bin/bash

mkdir Assoc
pop=1
while [ ${pop} -le 22 ];
do
 plink --vcf Impute/imputeTako${pop}.tri.vcf --assoc --allow-no-sex --mpheno 1 --pheno Pheno.txt --out Assoc/Tako${pop}.tri
 ((pop++))
done


