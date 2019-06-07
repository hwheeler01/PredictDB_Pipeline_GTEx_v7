#!/usr/bin/env python

'''make a run script for each chr/gene subset and output a qsub file'''

qsubfile = open('qsub.txt','w')
prescript = 'FHS_runscript_LDpruned_gene_subset'

for i in [10]:
    nk = str(i)
    for j in range(1,18): #check which chromosomes didn't finish
        c = str(j)
        for k in range(1,5):
            sub = str(k)
            outfilename = '002_run_' + prescript + '_' + c + '_' + nk + '_' + sub + '.sh'
            outfile = open(outfilename,'w')
            output = '''#!/bin/bash
#PBS -N sub_''' + c + '_' + sub +'''\n#PBS -S /bin/bash
#PBS -l walltime=240:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=32gb
#PBS -e ../joblogs/${PBS_JOBNAME}.err
#PBS -o ../joblogs/${PBS_JOBNAME}.out
cd $PBS_O_WORKDIR

module load gcc/6.2.0
module load R/3.5.0

time R --no-save < ''' + prescript + '.R --args ' + nk + ' ' + c + ' ' + sub + '\n'
            outfile.write(output)
            qsubfile.write('qsub ' + outfilename + '\nsleep 3\n')


