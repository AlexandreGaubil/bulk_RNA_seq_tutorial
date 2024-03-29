#!/bin/bash

### qsub file.name to run from anywhere

#PBS -N F_featureCounts
#PBS -S /bin/bash
#PBS -l walltime=12:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -o /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/featureCounts/F_featureCounts.out
#PBS -e /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/featureCounts/F_featureCounts.err

date

module load gcc/6.2.0
module load intel/2017
module load subread/1.5.3

####the    sequencing is strand specific, so we specified -s 1 as the forward strand. If you don't    know this information
####run    unspecified strand(default, you    don't need to put anything for -s, and -s 1  -s    2 respectively,    if it's    unstanded
####you    should see the     number of mapped genes to be 50% vs 50%    for reverse and    forward, if not, then it is stranded.
cd /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/star

featureCounts -a /gpfs/data/mcnerney-lab/liuweihan/cellranger_ref_genomes/mm10genes_chrM.gtf \
-t exon -g gene_id \
-s 1 \
-o /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/featureCounts/forward_counts_raw.txt \
*.sam

date
echo END