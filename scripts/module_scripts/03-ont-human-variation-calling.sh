#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition prod
#SBATCH --job-name=03-ont-human-variation-calling
#SBATCH --time=24:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 24
#SBATCH --mem 130G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE='OM1052A'
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
MODEL='dna_r10.4.1_e8.2_400bps_hac@v3.5.2'
REF="/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz"
TDREPETS='/NGS/humangenomics/active/2022/run/ont_human_workflow/demo_data_new/demo_data/human_GRCh38_no_alt_analysis_set.trf.bed'
NFCONFIG='/NGS/humangenomics/active/2022/run/ont_human_workflow/config/03-ont-human-variation-calling/nextflow.config'
# note: created an overide config to provide modified CPU and Memory values
# change these values if you want to tweak performance based on resources

# cleaup old ouputs of this script to avoid writing to file twice
rm -rf ${WKDIR}/results/03-ont-human-variation-calling/${SAMPLE}/

# create output directory if it doesn't yet exist
mkdir -p ${WKDIR}/results/03-ont-human-variation-calling/${SAMPLE}/work/
mkdir -p ${WKDIR}/results/03-ont-human-variation-calling/${SAMPLE}/

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with nextflow installed
mamba env create \
--force \
-f ${WKDIR}/scripts/envs/conda.nextflow.22.10.1.yml

# activate nextflow conda environment
conda activate nextflow.22.10.1

# run Clair3 variant calling and sniffles2
nextflow run -c ${NFCONFIG} epi2me-labs/wf-human-variation \
-r v1.0.0 \
-w ${WKDIR}/results/03-ont-human-variation-calling/${SAMPLE}/work/ \
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
--basecaller_cfg ${MODEL} \
--bam ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_merged_sorted.bam \
--ref ${REF} \
--sample_name ${SAMPLE} \
--out_dir ${WKDIR}/results/03-ont-human-variation-calling/${SAMPLE}/

# Notes:
# This step calls the ONT wf-human-variation nextflow pipeline
# (https://github.com/epi2me-labs/wf-human-variation), which performs variant calling (clair3),
# phase marking, and structural variant calling using sniffles2 (sniffles2 was a seperate step
# previously). 

#--tr_bed ${TDREPETS} \