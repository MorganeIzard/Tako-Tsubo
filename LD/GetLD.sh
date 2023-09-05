rm -f ALL_SIGNALS.LD.txt
VCF_DIR="/home/u1166/Documents/impute5_v1.1.5/impute5_v1.1.5/1000G"
for CHR in `cut -f1 TopSNP_CHR_POS.txt | sort | uniq | grep -v CHR`
do
 	if test -f "${VCF_DIR}/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz"; then
 		echo ${VCF_DIR}/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
 	else	
 		wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
 	fi

 	vcftools --gzvcf ${VCF_DIR}/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz --keep EuropeanAncestrySampleList.txt --recode --out EUR_only.${CHR} --mac 1
 	vcftools  --vcf EUR_only.${CHR}.recode.vcf  --ld-window-bp 1000000 --hap-r2-positions TopSNP_CHR_POS.txt
 	mv out.list.hap.ld chr${CHR}.LD
 	sed -e '1d' chr${CHR}.LD >> ALL_SIGNALS.LD.txt
 	rm ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz EUR_only.${CHR}.recode.vcf
 	rm chr*
done
