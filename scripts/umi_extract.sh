#!/bin/bash
#SBATCH --job-name=umitools
#SBATCH --mail-type=ALL
#SBATCH --mail-user=aj.trouerntrend@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=16:00:00
#SBATCH --qos=scripps-dept
#SBATCH --account=scripps-dept
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb
#SBATCH -o umitools.%j.out
#SBATCH -e umitools.%j.err

module load umi-tools/1.1.5

# Set input and output file names
INPUT_R1=$1 
INPUT_R2=${1/R1/R2}
OUTFOLDER="/path/to/output/folder"
OUTPUT_R1=$OUTFOLDER/$( basename $INPUT_R1)
OUTPUT_R2=$OUTFOLDER/$( basename $INPUT_R2)

umi_tools extract \
	--extract-method=regex \
	--bc-pattern="TAGGGAAAGAGTGT(.{8})" \
    	-o output_prefix  \
	-I $INPUT_R1 \
	--read2-in=$INPUT_R2 \
	-S $OUTPUT_R1 \
	--read2-out=$OUTPUT_R2

