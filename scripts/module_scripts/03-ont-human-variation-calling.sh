#!/bin/bash -l

#SBATCH --partition prod
#SBATCH --job-name=02-ont-human-variation-calling
#SBATCH --time=24:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 48
#SBATCH --mem 130G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
SAMPLE='demo'
MODEL='/NGS/clinicalgenomics/public_data/clair3_models/ont_guppy5/'
REFERENCE='/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz'
TDREPETS='/NGS/humangenomics/active/2022/run/ont_human_workflow/data/demo_data/human_GRCh38_no_alt_analysis_set.trf.bed'
NFCONFIG='/NGS/humangenomics/active/2022/run/ont_human_workflow/config/02-ont-human-variation-calling/nextflow.config'
# note: created an overide config to provide modified CPU and Memory values
# change these values if you want to tweak performance based on resources

# create output directory
mkdir ${WKDIR}/results/02-ont-human-variation-calling/

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with nextflow installed and activate it
mamba env create --force -f ${WKDIR}/scripts/envs/conda.nextflow.22.10.0.yml
conda activate nextflow

# run Clair3 variant calling and sniffles2
nextflow run -c ${NFCONFIG} epi2me-labs/wf-human-variation \
-r v0.3.1 \
-profile singularity \
-with-report \
-with-timeline \
-with-trace \
-resume \
--threads 24 \
--snp \
--sv \
--phase_vcf \
--use_longphase \
--tr_bed ${TDREPETS} \
--model ${MODEL} \
--bam ${WKDIR}/results/00-cthulhu-guppy-gpu/bam/${SAMPLE}_sorted_merged.bam \
--ref ${REFERENCE} \
--out_dir ${WKDIR}/results/02-ont-human-variation-calling/

# Notes:
# This step calls the ONT wf-human-variation nextflow pipeline
# (https://github.com/epi2me-labs/wf-human-variation), which performs variant calling (clair3),
# phase marking, and structural variant calling using sniffles2 (sniffles2 was a seperate step
# previously). 