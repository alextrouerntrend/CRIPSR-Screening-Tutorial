### CRISPR Screening Bioinformatics Analysis
We will review the process of analyzing CRISPR screening libraries using Mageck as a command-line tool and MageckFlute in RStudio. This will include the following steps:
	- Quality Control Checks
	- UMI Deduplication
	- Mageck count
	- MaGeCKFlute statistical analysis in R

All .sh scripts are currently setup to run on UFL's HiPerGator HPC system with my account, but the scripts can be modified to work on other systems that use SLURM. Just make sure the name of the modules are available on your system and named consistently in your altered script. Also modify the header according to your system's specifications and your user and group names.

#### Quality Control with FastQC
FastQC can be used to gather general library statistics and quality control metrics. The script ./scripts/fastqc.sh is called with the path to the fastq file to be QC-checked as an argument.
`sbatch fastqc.sh /path/to/samplex.fastq`

#### UMI Deduplication
Two functions from UMI-tools are used to deduplicate reads. First `umi_tools extract` handles is given a regex string to identify and extract UMIs from reads and adds them to their respective fastq header. Later `umi_tools dedup` identifies PCR duplicates in the aligned sequencing data. The scripts `./script/umi_extract.sh` and `./script/umi_dedup.sh` are used to call these functions on fastq and bam files, respectively.

#### Read Mapping to Reference


#### Mageck count and Mageck test


