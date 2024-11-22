#!/bin/bash
#SBATCH --job-name=bowtie2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=aj.trouerntrend@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=16:00:00
#SBATCH --qos=scripps-dept
#SBATCH --account=scripps-dept
#SBATCH --cpus-per-task=4
#SBATCH --mem=64gb
#SBATCH -o bowtie2.%j.out
#SBATCH -e bowtie2.%j.err

module load bowtie2
module load samtools

LIB_FASTA=""
BOWTIE_IDX="/path/to/bowtie/index/index_prefix"

# Align unpaired reads?

bowtie2-build --threads 4 --offrate 0 $LIB_FASTA $BOWTIE_IDX

OUTDIR="./bams"

# get reads
IN1=""
IN2=""

bowtie2 --very-sensitive -k 10 -p 4 --phred33 -x ./bt_db/sarscov2 -1 $IN1 -2 $IN2 \
    |  samtools view  -u  -  \
    |  samtools sort  -n  -o $OUTDIR/${BN1}_bowtie2.bam -
