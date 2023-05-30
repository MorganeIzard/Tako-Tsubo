#!/bin/bash
Rscript cov_maker.R
POP=OUT

sed -i 's/"//g' covar.txt
sed -i 's/"//g' covarnum.txt
sed -i 's/"//g' covarsmol.txt

plink --file ${POP} --covar covarnum.txt --write-covar --out covnum
plink --file ${POP} --covar covarsmol.txt --write-covar --out covsmol

sed -i 's/-9/0/g' covsmol.cov
sed -i 's/-9/0/g' covnum.cov

plink --file ${POP} --logistic --covar covsmol.cov --covar-name SEXE,PC1,PC2,PC3 --out covSPPP
plink --file ${POP} --logistic dominant --covar covsmol.cov --covar-name SEXE,PC1,PC2,PC3 --out covSPPP_D
plink --file ${POP} --logistic recessive --covar covsmol.cov --covar-name SEXE,PC1,PC2,PC3 --out covSPPP_R

Rscript NewMan.R
Rscript Scatter.R
