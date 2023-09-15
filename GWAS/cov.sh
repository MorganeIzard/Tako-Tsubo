#!/bin/bash
POP=post_out

Rscript cov_maker.R

sed -i 's/"//g' covar.txt
sed -i 's/"//g' covarnum.txt
sed -i 's/"//g' covarsmol.txt

plink --file ${POP} --covar covarnum.txt --write-covar --out covnum_${POP}
plink --file ${POP} --covar covarsmol.txt --write-covar --out covsmol_${POP}

sed -i 's/-9/0/g' covsmol_${POP}.cov
sed -i 's/-9/0/g' covnum_${POP}.cov

plink --file ${POP} --logistic --covar covsmol_${POP}.cov --covar-name SEXE,PC1,PC2,PC3 --out covSPPP_${POP}
plink --file ${POP} --logistic dominant --covar covsmol_${POP}.cov --covar-name SEXE,PC1,PC2,PC3 --out covSPPP_D_${POP}
plink --file ${POP} --logistic recessive --covar covsmol_${POP}.cov --covar-name SEXE,PC1,PC2,PC3 --out covSPPP_R_${POP}

Rscript NewMan.R
Rscript Scatter.R
