library(dplyr)
library(data.table)
library(R.utils)

cov <- fread('/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/dbs/FHS_2019-05-24_LDpruned_10PFs_signif.txt.gz')
newcov <- cov[duplicated(cov)==FALSE]

fwrite(newcov, '/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/dbs/FHS_2019-05-24_LDpruned_10PFs_signif_rm_dups.txt',sep=' ')
gzip('/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/dbs/FHS_2019-05-24_LDpruned_10PFs_signif_rm_dups.txt', 
	destname='/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/dbs/FHS_2019-05-24_LDpruned_10PFs_signif_rm_dups.txt.gz')
