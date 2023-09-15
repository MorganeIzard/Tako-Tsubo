#!/bin/bash

pop=1
while [ ${pop} -le 22 ];
do
 grep "^#\|INFO=1\|INFO=0\.[5-9]" Impute/imputeTako${pop}.FakeRS.vcf > Impute/imputeTako${pop}.tri.vcf
 ((pop++))
done




