#!/usr/bash

file_path=/gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/tophat_SNK015
samples=(output_s2 output_s3)

for i in ${samples[@]}
do
  echo $i
  sample_id=$file_path/$i/accepted_hits.bam
  echo $sample_id
  sample_srt_id=`echo $sample_id | awk -F "." '{print $1}’`
  echo $sample_srt_id
  echo $sample_srt_id.sorted.bam
  samtools sort -@ 8 $sample_id -o $sample_srt_id.sorted.bam
done