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

INPUT=$1
OUTPU=${INPUT/.bam/_dedup.bam}

# Run umi_tools dedup
umi_tools dedup \
	--stdin=IN_BAM \
	--stdout=OUT_BAM
