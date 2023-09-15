#!/bin/bash

pop=1
while [ ${pop} -le 22 ];
do
 sed "s/\([0-9]*\)\t\([0-9]*\)\t\./\1\t\2\t\1_\2/" Impute/imputeTako${pop}.vcf > Impute/imputeTako${pop}.FakeRS.vcf
 ((pop++))
done

