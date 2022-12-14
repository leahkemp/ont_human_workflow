#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition prod
#SBATCH --job-name=06-ont-sv-cutesv
#SBATCH --time=6:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --mem 128G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE="OM1052A"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"
REF="/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz"

# create output directory if it doesn't yet exist
mkdir -p ${WKDIR}/results/06-ont-sv-cutesv/${SAMPLE}/cutesv_tmp/

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with whatshap installed and activate it
mamba env create --force -f ${WKDIR}/scripts/envs/conda.cutesv.2.0.2.yml
conda activate cutesv.2.0.2

# move to working dir
cd ${WKDIR}/results/06-ont-sv-cutesv/${SAMPLE}/

# cuteSV processing
cuteSV \
-t 16 \
--max_cluster_bias_INS 100 \
--diff_ratio_merging_INS 0.3 \
--max_cluster_bias_DEL 100 \
--diff_ratio_merging_DEL 0.3 \
${WKDIR}/results/04-ont-whatshap-phase/${SAMPLE}/${SAMPLE}_sorted_merged.hp.bam \
${REF} \
${WKDIR}/results/06-ont-sv-cutesv/${SAMPLE}/${SAMPLE}_sv_cutesv.vcf \
${WKDIR}/results/06-ont-sv-cutesv/${SAMPLE}/cutesv_tmp/

# move back into otiginal working directory
cd ${WKDIR}

# Notes:
# this step is for evaluation of another structural variant caller, cuteSV. It's 
# often nice to have the ability to compare results between various tools. As 
# SVs are important to this project this step has been included in the process.
# For other projects it may well be enough to stop after processing step 06.
# This process outputs a vcf file with the structural variation recorded per
# line.
