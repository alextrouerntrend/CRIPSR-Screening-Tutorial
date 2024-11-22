#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --mail-type=ALL
#SBATCH --mail-user=aj.trouerntrend@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=16:00:00
#SBATCH --qos=scripps-dept
#SBATCH --account=scripps-dept
#SBATCH --cpus-per-task=4
#SBATCH --mem=5gb
#SBATCH -o fastqc.%j.out
#SBATCH -e fastqc.%j.err

module load fastqc

DEST_DIR=./
FASTQ_1=$1

fastqc -t 4 -o $DEST_DIR/FastQC $FASTQ_1

#module load fastq-screen
#fastq_screen --aligner bowtie2 --conf /blue/scripps-bas/pipelines/preprocess/preprocessDependencies/FastQ_Screen_Genomes/fastq_screen.conf --outdir $DEST_DIR/FastqScreen $DEST_DIR/TotalReads/${CATfile}fastq.gz

#if [ "$READTYPE" = "Paired" ] ; then
#        module load fastq-screen
#        fastqc -t 4 --extract -o $DEST_DIR/FastQC $DEST_DIR/TotalReads/${CATfile2}fastq.gz
#        fastq_screen --aligner bowtie2 --conf /blue/scripps-bas/pipelines/preprocess/preprocessDependencies/FastQ_Screen_Genomes/fastq_screen.conf --outdir $DEST_DIR/FastqScreen $DEST_DIR/TotalReads/${CATfile2}fastq.gz
#fi
