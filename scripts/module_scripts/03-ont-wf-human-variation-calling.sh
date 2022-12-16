#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition prod
#SBATCH --job-name=03-ont-wf-human-variation-calling
#SBATCH --time=24:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 24
#SBATCH --mem 130G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE="OM1052A"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"
MODEL="dna_r9.4.1_450bps_hac"
REF="/NGS/clinicalgenomics/public_data/encode/GRCh38/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta"
TDREPETS="/NGS/clinicalgenomics/public_data/beds/human_GRCh38_no_alt_analysis_set.trf.bed"

# cleaup old ouputs of this script to avoid writing to file twice
rm -rf "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/

# create output directory if it doesn't yet exist
mkdir -p "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/work/
mkdir -p "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with nextflow installed
mamba env create \
--force \
-f "${WKDIR}"/scripts/envs/conda.nextflow.22.10.1.yml

# activate nextflow conda environment
conda activate nextflow.22.10.1

# move to working dir
cd "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/

# run Clair3 variant calling and sniffles2
nextflow run -c "${WKDIR}"/config/03-ont-wf-human-variation-calling/nextflow.config epi2me-labs/wf-human-variation \
-r v1.0.0 \
-w "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/work/ \
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
--basecaller_cfg "${MODEL}" \
--tr_bed "${TDREPETS}" \
--bam "${WKDIR}"/results/02-ont-bam-merge/"${SAMPLE}"/"${SAMPLE}"_merged_sorted.bam \
--ref "${REF}" \
--sample_name "${SAMPLE}" \
--out_dir "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/

# move back into original working directory
cd "${WKDIR}"

# Notes:
# This step calls the ONT wf-human-variation nextflow pipeline
# (https://github.com/epi2me-labs/wf-human-variation), which performs variant calling (clair3),
# phase marking, and structural variant calling using sniffles2 (sniffles2 was a seperate step
# previously). 
