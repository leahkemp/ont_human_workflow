#!/bin/bash -l

#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --partition prod
#SBATCH --job-name=05-ont-sv-cutesv
#SBATCH --time=6:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --mem 128G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
SAMPLE='demo'
REFERENCE='/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz'
OUTPUT='/NGS/humangenomics/active/2022/run/ont_human_workflow/results/05-ont-sv-cutesv/'

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with whatshap installed and activate it
mamba env create --force -f ${WKDIR}/scripts/envs/conda.whatshap.1.6.yml
conda activate whatshap

# move to working dir
cd ${WKDIR}/${SAMPLE}
mkdir cutesv_tmp

# cuteSV processing
cuteSV -t 16 \
  --max_cluster_bias_INS 100 \
  --diff_ratio_merging_INS 0.3 \
  --max_cluster_bias_DEL 100 \
  --diff_ratio_merging_DEL 0.3 \
  ./bam/${SAMPLE}_sorted_merged.hp.bam \
  ${REFERENCE} \
  ${WKDIR}/results/05-ont-sv-cutesv/${SAMPLE}_sv_cutesv.vcf \
  ./cutesv_tmp

# Notes:
# this step is for evaluation of another structural variant caller, cuteSV. It's 
# often nice to have the ability to compare results between various tools. As 
# SVs are important to this project this step has been included in the process.
# For other projects it may well be enough to stop after processing step 06.
# This process outputs a vcf file with the structural variation recorded per
# line.