
#!/bin/bash
### qsub file.name to run from anywhere

#PBS -N PE_STAR_wrapper
#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -o /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/angela/star/star_queue.out
#PBS -e /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/angela/star/star_queue.err

date
module load gcc/6.2.0

for i in $(ls /gpfs/data/mcnerney-lab/liuweihan/bulk_RNA/angela/fastq/*fastq.gz)
do
echo $i
otherfilename="${i/R1/R2}"  #replace the "R1" in the filename with "R2"
qsub -v R1=$i,R2=$otherfilename pe_star_exe.sh
done
date
echo