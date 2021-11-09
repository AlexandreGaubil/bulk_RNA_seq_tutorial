#PBS -S /bin/bash

#PBS -l walltime=8:00:00
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -o /gpfs/data/mcnerney-lab/konecki/SNK015/comb/QC_output/fastqc.out
#PBS -e /gpfs/data/mcnerney-lab/konecki/SNK015/comb/QC_output/fastqc.err

module load java-jdk/1.10.0_1
module load fastqc/0.11.7

while getopts o:i: flag
do
    case "${flag}" in
        i) INPUT=${OPTARG};;
        o) OUTPUT=${OPTARG};;
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
fi

LOG=log_qc.log

for FILE in $(ls *fastq\.gz)
do
    echo $FILE
    fastqc -t 8 -o $OUTPUR $FILE 2>$LOG
done

echo END