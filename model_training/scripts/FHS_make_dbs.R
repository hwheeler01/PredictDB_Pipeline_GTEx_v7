library(dplyr)
library(RSQLite)
"%&%" <- function(a,b) paste(a,b, sep='')

driver <- dbDriver('SQLite')
gene_annot <- read.table("/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/prepare_data/expression/gencode.v19.genes.patched_contigs.parsed.txt", header = T, stringsAsFactors = F)

tiss = "FHS_10PFs"

  # Extra table ----
model_summaries <- read.table('../summary/' %&% 'FHS_2019-05-24_LDpruned_10PFs_chr1_model_summaries.txt', header = T, stringsAsFactors = F)
tiss_summary <- read.table('../summary/' %&% 'FHS_2019-05-24_LDpruned_10PFs_chr1_tiss_chr_summary.txt', header = T, stringsAsFactors = F)
  
n_samples <- tiss_summary$n_samples
  
for (i in 2:22) {
  model_summaries <- rbind(model_summaries,
                             read.table('../summary/' %&% 'FHS_2019-05-24_LDpruned_10PFs_chr' %&% as.character(i) %&% '_model_summaries.txt', header = T, stringsAsFactors = F))
  tiss_summary <- rbind(tiss_summary,
                             read.table('../summary/' %&% 'FHS_2019-05-24_LDpruned_10PFs_chr' %&% as.character(i) %&% '_tiss_chr_summary.txt', header = T, stringsAsFactors = F))
}
  
model_summaries <- rename(model_summaries, gene = gene_id)

conn <- dbConnect(drv = driver, '../dbs/FHS_2019-05-24_LDpruned_10PFs.db')
dbWriteTable(conn, 'model_summaries', model_summaries, overwrite = TRUE)
dbGetQuery(conn, "CREATE INDEX gene_model_summary ON model_summaries (gene)")
  
  # Weights Table -----
weights <- read.table('../weights/' %&% 'FHS_2019-05-24_LDpruned_10PFs_chr1_weights.txt', header = T, stringsAsFactors = F)
for (i in 2:22) {
  weights <- rbind(weights,
                     read.table('../weights/' %&% 'FHS_2019-05-24_LDpruned_10PFs_chr' %&% as.character(i) %&% '_weights.txt', header = T, stringsAsFactors = F))
}
weights <- rename(weights, gene = gene_id)
dbWriteTable(conn, 'weights', weights, overwrite = TRUE)
dbGetQuery(conn, "CREATE INDEX weights_rsid ON weights (rsid)")
dbGetQuery(conn, "CREATE INDEX weights_gene ON weights (gene)")
dbGetQuery(conn, "CREATE INDEX weights_rsid_gene ON weights (rsid, gene)")
  
# Sample_info Table ----
sample_info <- data.frame(n_samples = n_samples, population = 'europeans', tissue = tiss)
dbWriteTable(conn, 'sample_info', sample_info, overwrite = TRUE)

# Construction Table ----
construction <- tiss_summary %>%
                  select(chrom, cv_seed) %>%
                  rename(chromosome = chrom)
dbWriteTable(conn, 'construction', construction, overwrite = TRUE)

