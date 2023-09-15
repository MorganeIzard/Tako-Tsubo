Commencer avec des fichiers de format .ped .map ou .bed .bim .fam 

Le nettoyage commence avec 
`bash clean.sh`

Au besoin, nettoyer manuellement le fichier ibd.txt pour y laisser les individus a retirer
Cela doit être au forma:
IIF FID 
Ensuite utiliser :
`plink --file SexCheck/donne_sc --remove IBD/ibd.txt --recode --out donnee_IBD`

Pour continuer le nettoyage, utiliser :
`bash clean_next.sh`

Maintenant il faut préparer les fichiers pour fusionner nos données aux données de HapMap, télécharger ici:
https://www.well.ox.ac.uk/~wrayner/tools/HRC-1000G-check-bim-v4.3.0.zip

Il faut les fréquences alléliques, utilisez:
`plink --file donnee_cohorte --freq --out d_freq`
`plink --file h_freq --freq --out d_hap`

Utiliser la commande sur les deux fichiers:
`perl HRC-1000G-check-bim.pl -b <bim file> -f <Frequency file> -r <Reference panel> -h`

~~~~
~~~~

Pour fusionnez les fichiers, utilisez:
`bash merge.sh`

Et afficher l'ACP avec PCA.R

Une fois que les outliers sont identifiés, rassemblez les dans un fichier 'outlier.txt'
`mkdir Post_outlier`
`plink --file HWE/donnee_hwe --remove outlier.txt --recode --out Post_outlier/donnee_PO`

Pour l'analyse faire:
`bash Analyse.sh`

Utiliser Man.R pour afficher le Manhattan plot et les signaux au dessus des seuils

Pour pousser l'analyse et faire une régression linéraire sur des covariables, utiliser:
`bash cov.sh`

#!!Ne pas oublier de vérifier la concordance dans les noms de fichiers
