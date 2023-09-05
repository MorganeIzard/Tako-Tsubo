GTEX data directly downloaded from GTEx website

https://storage.googleapis.com/gtex_analysis_v8/rna_seq_data/gene_tpm/gene_tpm_2017-06-05_v8_heart_left_ventricle.gct.gz

Some R transformation:

>library("data.table")
>I<-fread("gene_tpm_2017-06-05_v8_heart_left_ventricle.gct")
>SampleNames<-colnames(I)[grep("GTEX",colnames(I))]
>I.long<-melt(I,measure.vars=SampleNames,variable.name="Sample",value.name="TPM",id.vars="Description")
>I.long<-I.long[ , .(Mean_expr = mean(TPM)), by = Description]
>fwrite(I.long,"Avg.Rlong.tsv",sep="\t")

