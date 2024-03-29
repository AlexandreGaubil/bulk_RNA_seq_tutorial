#!/bin/bash

### qsub file.name to run from anywhere

#PBS -N STAR_mkref
#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -o /gpfs/data/mcnerney-lab/liuweihan/bulk_refgenomes/star_mkref.out
#PBS -e /gpfs/data/mcnerney-lab/liuweihan/bulk_refgenomes/star_mkref.err

date

module load gcc/6.2.0
module load STAR/2.6.1d

STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /gpfs/data/mcnerney-lab/liuweihan/bulk_refgenomes/mm10_refgenome \
--genomeFastaFiles /gpfs/data/mcnerney-lab/mcnerney/reference/mm10/mm10genome.fa \
--sjdbGTFfile /gpfs/data/mcnerney-lab/liuweihan/cell_ranger_ref_genomes/mm10genes_chrM.gtf

date
echo END