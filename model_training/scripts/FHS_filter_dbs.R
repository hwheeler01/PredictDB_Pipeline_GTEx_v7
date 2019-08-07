library(dplyr)
library(RSQLite)
"%&%" <- function(a,b) paste(a,b,sep='')

driver <- dbDriver("SQLite")

unfiltered_db <- "/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/dbs/FHS_2019-05-24_LDpruned_10PFs.db"
filtered_db <- "/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/dbs/FHS_2019-05-24_LDpruned_10PFs_signif.db"
in_conn <- dbConnect(driver, unfiltered_db)
out_conn <- dbConnect(driver, filtered_db)
model_summaries <- dbGetQuery(in_conn, 'select * from model_summaries where zscore_pval < 0.05 and rho_avg > 0.1')
model_summaries <- model_summaries %>% rename(pred.perf.R2 = rho_avg_squared, genename = gene_name, pred.perf.pval = zscore_pval, n.snps.in.model = n_snps_in_model)
model_summaries$pred.perf.qval <- NA
dbWriteTable(out_conn, 'extra', model_summaries)
construction <- dbGetQuery(in_conn, 'select * from construction')
dbWriteTable(out_conn, 'construction', construction)
sample_info <- dbGetQuery(in_conn, 'select * from sample_info')
dbWriteTable(out_conn, 'sample_info', sample_info)
weights <- dbGetQuery(in_conn, 'select * from weights')
weights <- weights %>% filter(gene %in% model_summaries$gene) %>% rename(eff_allele = alt, ref_allele = ref, weight = beta)
dbWriteTable(out_conn, 'weights', weights)
dbGetQuery(out_conn, "CREATE INDEX weights_rsid ON weights (rsid)")
dbGetQuery(out_conn, "CREATE INDEX weights_gene ON weights (gene)")
dbGetQuery(out_conn, "CREATE INDEX weights_rsid_gene ON weights (rsid, gene)")
dbGetQuery(out_conn, "CREATE INDEX gene_model_summary ON extra (gene)")

