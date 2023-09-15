#!/bin/bash
#découpe le fichier common_all_20180423.vcf afin qu'il soit plus facile a charger dans R
for CHR in `cut -f1 TopSNP_CHR_POS.txt | sort | uniq | grep -v CHR`
do
 grep "^#\|^${CHR}" only_snv.vcf > only_snv_${CHR}.vcf
done
