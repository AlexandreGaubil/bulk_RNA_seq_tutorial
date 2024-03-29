
#!/bin/bash
### qsub file.name to run from anywhere

#PBS -N PE_STAR
#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -o /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/angela/star/star_exe.out
#PBS -e /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/angela/star/star_exe.err

date
module load gcc/6.2.0
module load STAR/2.6.1d

cd /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/angela/fastq
out=/gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/angela/star/output

echo $R1
echo $R2

STAR --runThreadN 8 \
--genomeDir /gpfs/data/mcnerney-lab/liuweihan/CUX1_CASP_diff_ref_transcriptome_bulk/mm10_refgenome \
--readFilesIn $R1 $R2 \
--outFileNamePrefix $R1 \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \


date
echo