# detailed steps of RNA seq
This readme file contains all the code and comments to perform a complete bulk RNA seq up until featureCounts. For the steps after featureCounts, namely DeSeq2 and GO/GSEA analysis, please see the R markdown files in this folder. Note all of the steps below are written in shell scripts. Below are the main codes of each steps for educational purposes, see the script for each step for complete ready-to-run codes.

## 1.FastQC


**specifies the path to input files:**
```
s1=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-1_S1_L005_R1_001_merged.fastq.gz
s2=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-2_S2_L005_R1_001_merged.fastq.gz
s3=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-3_S3_L005_R1_001.fastq_merged.gz
s4=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-4_S4_L005_R1_001_merged.fastq.gz
s5=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-5_S5_L005_R1_001_merged.fastq.gz
s6=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-6_S6_L005_R1_001_merged.fastq.gz
s7=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-7_S7_L005_R1_001_merged.fastq.gz
s8=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-8_S8_L005_R1_001_merged.fastq.gz
s9=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/ MMc-9_S9_L005_R1_001_merged.fastq.gz
s10=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-10_S10_L005_R1_001_merged.fastq.gz
s11=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-11_S11_L005_R1_001_merged.fastq.gz
s12=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/MMc-12_S12_L005_R1_001_merged.fastq.gz

### specify the output directory and where you would like to put the log file, which logs all the steps of the job running, for debugging purposes.
out=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/fastqc
log=/gpfs/data/mcnerney-lab/liuweihan/SNK015/merged/fastqc/fastqc.log

### main command
fastqc -t 8 -o $out $s1 $s2 $s3 $s4 $s5 $s6 $s7 $s8 $s9 $s10 $s11 $s12 2> $log
```

**alternatively, you could implement fastqc locally in R using the fastqcr package. Please see the file fastqc_in_R.Rmd for details**

## 2.STAR 

**first, make a customized reference genome for STAR aligner.This only needs to be done once for each genome. You can also find ready-to-use ref genomes on STAR websites. In this experiment we constructed a mm10 reference genome which can differentiate CUX1 vs Casp.**
```
STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /gpfs/data/mcnerney-lab/liuweihan/bulk_refgenomes/mm10_refgenome \
--genomeFastaFiles /gpfs/data/mcnerney-lab/mcnerney/reference/mm10/mm10genome.fa \
--sjdbGTFfile /gpfs/data/mcnerney-lab/liuweihan/cell_ranger_ref_genomes/mm10genes_chrM.gtf
```
**then, we run star to align the reads to our reference genome, note I wrote a for loop here to loop through all the fastq files and automate the process.**
```
cd /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged

for i in $(ls *.fastq.gz)
do
echo $i
sample_prefix=`echo $i | awk -F "L005" '{print $1}'`
echo $sample_prefix

STAR --runThreadN 8 \
--genomeDir /gpfs/data/mcnerney-lab/liuweihan/bulk_refgenomes/mm10_refgenome \
--readFilesIn $i \
--readFilesCommand gunzip \
--outFileNamePrefix $sample_prefix \

done
```

## 2.1 RUN STAR for batch
**We can run STAR in batch for many fastqs using a wrapper.**
In the above files, use the combination of star_PE_wrapper and star_PE_exe. star_PE_exe contain the actual code to execute star for each pair of reads. star_PE_wrapper contain the code to loop through each pair of fastqs and send them for execution in star_PE_exe.  When execute in the cluster, all you need to do is to execute the star_PE_wrapper script using ./star_PE_wrapper.(the normal way how to execute a bash script) Note please do not use qsub to execute because qsub within the wrapper script is not recognized in this way.

## 3.SAMTools(optional for differential expression analysis)

**read in samples**
file_path=/gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/tophat_SNK015
samples=(output_s2 output_s3 output_s4 output_s5 output_s6 output_s7 output_s8 output_s9 output_s10 output_s11 output_s12)

**samtools sort and q30 filter.You don't need to do this if you just want to do differential expression analysis, because illumina sequencing platform already has pretty high accurate base calling and featureCount will sort the reads itself.This is more useful is you want to visualize your reads with IGV or do other downstream analysis**
```
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
```

## 4.featureCounts
**this sequencing experiment is strand specific, so we specified -s 1 as the forward strand. If you don't know this information,run    unspecified strand(default, you don't need to put anything for -s) and run -s 1 , -s 2 respectively, if it's unstanded,you should see the    number of mapped genes to be 50% vs 50% for reverse and forward, if not, then it is stranded.**

```
cd /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/star

featureCounts -a /gpfs/data/mcnerney-lab/liuweihan/cellranger_ref_genomes/mm10genes_chrM.gtf \
-t exon -g gene_id \
-s 1 \
-o /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/SNK015/merged/featureCounts/forward_counts_raw.txt \
*.sam
```

## 5.Differential Expression analysis using DeSeq2
**see the two .Rmd file for details**

## 6.GSEA/GO analysis
**see the fgsea file for detail**

