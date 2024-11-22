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
OUTPUT="deduplicated.fastq.gz"

# UMI parameters
UMI_START=29
UMI_END=37
UMI_SIZE=$((UMI_END - UMI_START + 1)) 

umi_tools extract \
    --extract-method=regex \
    --bc-pattern="TAGGGAAAGAGTGT(.{8})" \
    -o output_prefix  


# Run umi_tools dedup
umi_tools dedup \
    -I ${INPUT_R1} \
    -S ${INPUT_R2} \
    --umi-method="extract" \
    --extract-method="string" \
    --umi-start=${UMI_START} \
    --umi-length=${UMI_SIZE} \
    -O ${OUTPUT}
