#!/bin/bash
awk '{print $2}' hap-updated.map > tmp_hmap
awk '{print $2}' donnee-updated.map > tmp_dmap
sort tmp_hmap > s_hmap
sort tmp_dmap > s_dmap
rm tmp*
comm -1 -2 s_hmap s_dmap > sort_file
rm s_hmap
rm s_dmap
plink --file hap-updated --extract sort_file --recode --out hap_test
plink --file donnee-updated --extract sort_file --recode --out donnee_test
plink --file hap_test --make-bed --out hap_test
plink --file donnee_test --make-bed --out donnee_test
plink --bfile hap_test --bmerge donnee_test --out merge_test
plink --file donnee_test --flip merge_test.missnp --recode --out donnee_test
plink --file donnee_test --make-bed --out donnee_test 
plink --file hap_test --merge donnee_test --out merge_test
