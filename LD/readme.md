1KGP phased haplotypes file:

`wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz`

Sample to population corresponding file obtained from https://www.internationalgenome.org/data-portal/sample

[here](./igsr_samples.tsv)

`grep "European Ancestry" igsr_samples.tsv  | cut -f1  > EuropeanAncestrySampleList.txt`

use vcftools [conda recipe](./vcftool.conda_recipe.txt) to

1 extract european samples with at least one polymorphism

`vcftools --gzvcf ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz --keep EuropeanAncestrySampleList.txt --recode --out EUR_only.vcf --mac 1`

2 compute LD of a particular SNP

`vcftools  --vcf EUR_only.vcf  --ld-window-bp 1000000 --hap-r2-positions LOCAL_POS.txt`


The SCRIPT GetLD.sh does it for a whole list of signals

Givent a LOCAL_POS.txt file with  chr and position of signals

Get if needed the 1KGP file
Extract europeen population
Compute the LD from la window of 100000 bp
Concat every LD measurement into a file
delete intermediary files


Will make a file that will have all snps within 100000 of all our signals and compute their LD by position. Will need to be filtered based on R^2 threshold

CHR1    POS1    CHR2    POS2    N_CHR   R^2
10      28240225        10      27240266        1006    0.00510889
10      28240225        10      27240275        1006    0.000893645



