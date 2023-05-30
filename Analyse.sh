#!/bin/bash
POP=OUT
plink --file ${POP} --make-bed --out ${POP}
plink --file ${POP} --pca var-wts --out ${POP}_pca
plink --file ${POP} --assoc fisher --out ${POP}
plink --file ${POP} --model fisher --out ${POP}

