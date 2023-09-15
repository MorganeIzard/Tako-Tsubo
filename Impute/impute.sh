#!/bin/bash

mkdir Impute
pop=1
while [ ${pop} -le 22 ];
do
 if test -f "1000G/chr${pop}ref.imp5"; then 
  echo 1000G/chr${pop}ref.imp5
  ./impute5_1.1.5_static --h 1000G/chr${pop}ref.imp5 --g Phasage/Takotsubo${pop}.vcf.gz --r ${pop} --threads --o Impute/imputeTako${pop}.vcf.gz
 else
  ./impute5_1.1.5_static --h 1000G/ALL.chr${pop}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz --g Phasage/Takotsubo${pop}.vcf.gz --r ${pop} --threads 7 --o Impute/imputeTako${pop}.vcf.gz
 ((pop++))
done
