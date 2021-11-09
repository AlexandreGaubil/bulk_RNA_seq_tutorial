#!/bin/bash

### qsub file.name to run from anywhere

#PBS -N samtools_SNK015
#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -o /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/filtered_bam/samtools.out
#PBS -e /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/filtered_bam/samtools.err

date

module load gcc/6.2.0
module load samtools/1.6.0

#read in samples
file_path=/gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/tophat_SNK015
samples=(output_s2 output_s3 output_s4 output_s5 output_s6 output_s7 output_s8 output_s9 output_s10 output_s11 output_s12)

####samtools sort

for i in ${samples[@]}
do
echo $i
sample_id=$file_path/$i/accepted_hits.bam
echo $sample_id
sample_srt_id=`echo $sample_id | awk -F "." '{print $1}'`
echo $sample_srt_id
echo $sample_srt_id.sorted.bam
samtools sort -@ 8 $sample_id -o $sample_srt_id.sorted.bam
samtools view -@ 8 -bh -q 30 $sample_srt_id.sorted.bam -o $sample_srt_id.sorted.q30.bam
done

date
echo END









