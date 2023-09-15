#!/bin/bash

pop=1
while [ ${pop} -le 22 ];
do
 tabix -p vcf ALL.chr${pop}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
 ((pop++))
done


