#!/bin/bash

pop=1
while [ ${pop} -le 22 ];
do
 ./imp5Converter_1.1.5_static --h 1000G/ALL.chr${pop}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz --r ${pop} --o 1000G/chr${pop}ref.imp5
 ((pop++))
done





