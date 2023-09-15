#!/bin/bash

mkdir Model
pop=1
while [ ${pop} -le 22 ];
do
 plink --vcf Impute/imputeTako${pop}.tri.vcf --model --allow-no-sex --mpheno 1 --pheno Pheno.txt --out Model/Tako${pop}.tri
 ((pop++))
done


