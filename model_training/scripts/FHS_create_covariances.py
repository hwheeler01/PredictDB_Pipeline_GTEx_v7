#!/bash/python

import gzip
import sqlite3


dbdir='/gpfs/data/im-lab/nas40t2/hwheeler/ancestry-px/PredictDB_Pipeline_GTEx_v7/model_training/dbs/'
# Get set of genes with significant models
conn = sqlite3.connect(dbdir + 'FHS_2019-05-24_LDpruned_10PFs_signif.db')
c = conn.cursor()
c.execute('select gene from extra')
signif_genes = {row[0] for row in c.fetchall()}
conn.close()
with gzip.open(dbdir + 'FHS_2019-05-24_LDpruned_10PFs_signif.txt.gz', 'w') as cov_out:
    hdr = ' '.join(['GENE', 'RSID1', 'RSID2', 'VALUE']) + '\n'
    cov_out.write(hdr.encode('utf-8'))
    with gzip.open(dbdir + 'FHS_2019-05-24_LDpruned_10PFs.txt.gz') as cov_in:
        # Skip header
        line = cov_in.readline()
        for line in cov_in:
            gene = line.strip().split()[0]
            if gene in signif_genes:
                cov_out.write((line.strip() +'\n').encode('utf-8')) 

