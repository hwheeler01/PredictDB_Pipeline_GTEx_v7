"%&%" = function(a,b) paste(a,b,sep="")
source("/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/scripts/gtex_v7_nested_cv_elnet.R")

args <- commandArgs(trailingOnly=T)

Nk <- args[1] #number PFs
chrom <- args[2] 

mydir <- "/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/prepare_data/"
snp_annot_file <- mydir %&% "genotype/FHS_2019-05-01/chr" %&% chrom %&% "_snp_annot_dbSNP151_LDpruned.txt"
gene_annot_file <- mydir %&% "expression/gencode.v19.genes.patched_contigs.parsed.txt"
genotype_file <- mydir %&% "genotype/FHS_2019-05-01/chr" %&% chrom %&% "_dosage_maf01.r2_8.dbSNP151_LDpruned.txt.gz"
expression_file <- mydir %&% "expression/FHS_2019-05-16/FHS_adjEXP_peer_Nk-" %&% Nk %&% ".txt"
covariates_file <- mydir %&% "covariates/FHS_2019-04-02/FHS_eur_10_gt_PCs_covariates.txt"
prefix1 <- "FHS_nested_cv_LDpruned"
prefix2 <- "FHS_2019-05-24_LDpruned_" %&% Nk %&% "PFs"


#chrom in this function must be numeric, null_testing=FALSE (to run EN)
main(snp_annot_file, gene_annot_file, genotype_file, expression_file, covariates_file, as.numeric(chrom), prefix2, null_testing=FALSE)

