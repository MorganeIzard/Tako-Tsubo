Une fois que les fichiers sont phasés et que les fichiers vcf de référence de 1000G sont dans le dossier 1000G
Au cas où il manque les fichiers index, complémentaires aux fichiers vcf:
`bash index.sh`

Pour accélérer l'imputation, il est possible de passer les fichiers vcf de 1000G au format .imp5 pour que le logiciel fasse l'imputation plus rapidement
`bash convert_imp5.sh`

Pour les fichiers phasés, il faut les passer au format vcf, avec leur index:
`bash zip_vcf.sh`

Ensuite on fait l'imputation a l'aide d'IMPUTE5 (https://jmarchini.org/software/#impute-5)
`bash impute.sh`

Si les fichiers de références n'ont pas les identifiants des SNPs, on peut mettre le CHR_BP à la place:
`bash FakeRS.sh`

On peut aussi trier les SNPs en fonction de leur R² après l'imputation 
`bash tri_R_Squarrend.sh`

On peut ensuite faire l'analyse d'association, il nous faut le fichier Pheno.txt qui est tiré du fichier .fam et qui est sous format
IID FID PHENO 
`bash assoc.sh`

Il est également possible de faire l'association selon différent modèle
`bash model.sh`

On peut alors faire ressortir les signaux au dessus du seuil donné
`bash significatif.sh`

Ensuite on modifie le fichier afin d'afficher les différents signaux
`bash prepTopSNP.sh`
