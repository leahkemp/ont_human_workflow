#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition prod
#SBATCH --job-name=04-ont-whatshap-phase
#SBATCH --time=24:00:00
#SBATCH --ntasks 8
#SBATCH --cpus-per-task 16
#SBATCH --mem 64G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE="OM1052A"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"
REF="/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz"

# create output directory if it doesn't yet exist
mkdir -p "${WKDIR}"/results/04-ont-whatshap-phase/"${SAMPLE}"/

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with whatshap installed
# after looking further into it Guix don't plan to support the direct linking of
# base libs like libz in python virtual environments. I need to think more about
# this issue, but for now conda works.
mamba env create \
--force \
-f "${WKDIR}"/scripts/envs/conda.whatshap.1.7.yml

# activate whatshap conda environment
conda activate whatshap.1.7

# whatshap phase tagging of bam output
whatshap haplotag \
"${WKDIR}"/results/03-ont-human-variation-calling/"${SAMPLE}"/"${SAMPLE}".wf_snp.vcf.gz \
"${WKDIR}"/results/02-ont-bam-merge/"${SAMPLE}"/"${SAMPLE}"_merged_sorted.bam \
--output "${WKDIR}"/results/04-ont-whatshap-phase/"${SAMPLE}"/"${SAMPLE}"_sorted_merged.hp.bam  \
--reference "${REF}" \
--ignore-read-groups

# create conda environment with samtools installed
mamba env create \
--force \
-f "${WKDIR}"/scripts/envs/conda.samtools.1.16.1.yml

# activate samtools conda environment
conda activate samtools.1.16.1

# index bam
samtools index \
-@ 16 \
"${WKDIR}"/results/04-ont-whatshap-phase/"${SAMPLE}"/"${SAMPLE}"_sorted_merged.hp.bam

# Notes:
# this step phases the data based on the clair3 output and generates a 
# phased bam file. This contains information assigning reads to each
# haplotype. At this stage the bam is able to loaded into a genome 
# viewer/browser and contains aligned reads, with base modification
# (methylation) information, as well as the haplotype information.
