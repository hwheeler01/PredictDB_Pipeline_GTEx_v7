"%&%" = function(a,b) paste(a,b,sep="")
source("/gpfs/data/im-lab/nas40t2/hwheeler/GitHub/PredictDB_Pipeline_GTEx_v7/model_training/scripts/gtex_v7_nested_cv_elnet.R")

mydir <- "/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/prepare_data/"
snp_annot_file <- mydir %&% "genotype/FHS_2019-05-01/chr22_snp_annot_dbSNP151.txt"
gene_annot_file <- mydir %&% "expression/gencode.v19.genes.patched_contigs.parsed.txt"
genotype_file <- mydir %&% "genotype/FHS_2019-05-01/chr22_dosage_maf01.r2_8.dbSNP151.txt.gz"
expression_file <- mydir %&% "expression/FHS/FHS_adjEXP_peer_Nk-10.txt"
covariates_file <- mydir %&% "covariates/FHS_2019-04-02/FHS_eur_10_gt_PCs_covariates.txt"
chrom <- 22
prefix1 <- "FHS_nested_cv"
prefix2 <- "FHS_nested_cv_permuted"

main(snp_annot_file, gene_annot_file, genotype_file, expression_file, covariates_file, chrom, prefix2, null_testing=TRUE)

