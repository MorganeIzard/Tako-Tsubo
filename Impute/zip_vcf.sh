#!/bin/bash

pop=1
while [ ${pop} -le 22 ];
do
 bgzip -c Phasage/Takotsubo.${pop} > Phasage/Takotsubo${pop}.vcf.gz
 tabix -p vcf Phasage/Takotsubo${pop}.vcf.gz

 ((pop++))
done

