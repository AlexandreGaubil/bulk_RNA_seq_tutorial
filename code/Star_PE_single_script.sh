#!/usr/bin/env bash
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
module load STAR/2.6.1d

while getopts o:i:g: flag
do
    case "${flag}" in
        i) INPUT=${OPTARG};;
        o) OUTPUT=${OPTARG};;
        g) GENOME_DIR=${OPTARG};;
    esac
done

# Check if all flags were set
if [ -z "$INPUT" ]
then
    echo "No input directory specified, please specify it using the -i flag"
    exit 1
else
    cd $INPUT
fi

if [ -z "$OUTPUT" ]
then
    echo "No output directory specified, please specify it using the -o flag"
    exit 1
else
    out=$OUTPUT
fi

if [ -z "$GENOME_DIR" ]
then
    echo "No reference genome directory specified, please specify it using the -g flag"
    exit 1
fi

# Function to run STAR for the given R1 and R2 files (R1 is $1 and R2 is $2)
run_STAR() {
    STAR --runThreadN 8 \
    --genomeDir $GENOME_DIR \
    --readFilesIn $1 $2 \
    --outFileNamePrefix $1 \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \

}

# Loop through the files with extension .fastq.gz in the current directory
for FILENAME in $(ls *.fastq.gz)
    do
    echo $FILENAME
    # Replace the "R1" in the filename with "R2"
    OTHER_FILENAME="${i/R1/R2}"
    run_STAR $FILENAME $OTHER_FILENAME
done

date
echo