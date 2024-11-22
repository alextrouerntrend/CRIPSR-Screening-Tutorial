#!/bin/bash
#SBATCH --job-name=mageck
#SBATCH --mail-type=ALL
#SBATCH --mail-user=aj.trouerntrend@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=16:00:00
#SBATCH --qos=scripps-dept
#SBATCH --account=scripps-dept
#SBATCH --cpus-per-task=1
#SBATCH --mem=30gb
#SBATCH -o mageck.%j.out
#SBATCH -e mageck.%j.err

module load mageck/0.5.9.4

mageck count -l hdc_table2.csv \
		-n mageck_trimmed_noUMI \
		--sample-label DA2-crl,DA3-low-pair1,DA3-low-pair2,DA3-high-pair1,DA3-high-pair2 \
		--control-sgrna control_list.txt \
		--fastq DA2-crl_R1_001.fastq DA3-low-pair1_R1_001.fastq DA3-low-pair2_R1_001.fastq DA3-high-pair1_R1_001.fastq DA3-high-pair2_R1_001.fastq \
		--fastq-2  DA2-crl_R2_001.fastq DA3-low-pair1_R2_001.fastq DA3-low-pair2_R2_001.fastq DA3-high-pair1_R2_001.fastq DA3-high-pair2_R2_001.fastq


mageck test -k mageck_trimmed_noUMI.count.txt -t DA3-low-pair1 -c DA2-crl -n DA3-low-pair1
mageck test -k mageck_trimmed_noUMI.count.txt -t DA3-low-pair2 -c DA2-crl -n DA3-low-pair2
mageck test -k mageck_trimmed_noUMI.count.txt -t DA3-high-pair1 -c DA2-crl -n DA3-high-pair1
mageck test -k mageck_trimmed_noUMI.count.txt -t DA3-high-pair2 -c DA2-crl -n DA3-high-pair2
