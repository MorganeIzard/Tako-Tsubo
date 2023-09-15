#!/bin/bash
FILE_DIR=Post_outlier/donnee_PO
plink --file ${FILE_DIR} --make-bed --out ${FILE_DIR}
plink --file ${FILE_DIR} --pca var-wts --out ${FILE_DIR}_pca
plink --file ${FILE_DIR} --assoc fisher --out ${FILE_DIR}
plink --file ${FILE_DIR} --model fisher --out ${FILE_DIR}

