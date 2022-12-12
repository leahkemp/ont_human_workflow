#!/bin/bash -l

#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --partition prod
#SBATCH --job-name=03-ont-whatshap-phase
#SBATCH --time=24:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --mem 64G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
SAMPLE='proband'
REFERENCE='/public-data/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna'
OUTPUT='results'

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with whatshap installed
# after looking further into it Guix don't plan to support the direct linking of
# base libs like libz in python virtual environments. I need to think more about
# this issue, but for now conda works.
mamba env create \
--force \
-f ${WKDIR}/scripts/envs/conda.whatshap.1.6.yml

# activate whatshap conda environment
conda activate whatshap.1.6

# move to working dir
cd ${WKDIR}/${SAMPLE}

# whatshap phase tagging of bam output
whatshap haplotag \
--ignore-read-groups \
--output ${WKDIR}/results/03-ont-whatshap-phase/${SAMPLE}_sorted_merged.hp.bam  \
--reference ${REFERENCE} \
--ignore-read-groups \
${WKDIR}/results/03-ont-whatshap-phase/all.wf_snp.vcf.gz \
${WKDIR}/results/03-ont-whatshap-phase/${SAMPLE}_sorted_merged.bam

# create conda environment with samtools installed
mamba env create \
--force \
-f ${WKDIR}/scripts/envs/conda.samtools.1.16.1.yml

# activate samtools conda environment
conda activate samtools.1.16.1

# index bam
samtools index \
-@ 16 ${WKDIR}/results/00-cthulhu-guppy-gpu/bam/${SAMPLE}_sorted_merged.hp.bam

# conda
conda deactivate

# Notes:
# this step phases the data based on the clair3 output and generates a 
# phased bam file. This contains information assigning reads to each
# haplotype. At this stage the bam is able to loaded into a genome 
# viewer/browser and contains aligned reads, with base modification
# (methylation) information, as well as the haplotype information.