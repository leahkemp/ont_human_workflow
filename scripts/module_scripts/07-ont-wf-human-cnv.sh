#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition prod
#SBATCH --job-name=07-ont-wf-human-cnv
#SBATCH --time=
#SBATCH --ntasks 1
#SBATCH --cpus-per-task
#SBATCH --mem
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE='OM1052A'
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
REF='/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz'

# create output directory if it doesn't yet exist
mkdir -p ${WKDIR}/results/07-ont-wf-human-cnv/

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with nextflow installed
mamba env create \
--force \
-f ${WKDIR}/scripts/envs/conda.nextflow.22.10.1.yml

# activate nextflow conda environment
conda activate nextflow.22.10.1

# run copy number variant calling
nextflow run epi2me-labs/wf-cnv \
-r v0.0.3 \
--fastq ${WKDIR}/results/00-cthulhu-guppy-gpu/basecalled/fastq/ \
--sample_sheet sample_sheet.csv \
--fasta ${REF} \
--genome hg38 --bin_size 500

# move back into otiginal working directory
cd ${WKDIR}
