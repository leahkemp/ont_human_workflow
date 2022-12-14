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
SAMPLE="OM1052A"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"
REF="/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz"

# create output directory if it doesn't yet exist
mkdir -p "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/work/
mkdir -p "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/pass/fastq/ 

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with nextflow installed
mamba env create \
--force \
-f "${WKDIR}"/scripts/envs/conda.nextflow.22.10.1.yml

# activate nextflow conda environment
conda activate nextflow.22.10.1

# put fastq files in a single directory named "fastq" - Miles notes the pipeline seems to require this
rsync -av "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/pass/*.fastq "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/pass/fastq/

# run copy number variant calling
nextflow run -c "${WKDIR}"/config/07-ont-wf-human-cnv/nextflow.config epi2me-labs/wf-cnv \
-r v0.0.3 \
-w "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/work/ \
-profile singularity \
-with-report \
-with-timeline \
-with-trace \
-resume \
--fastq "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/pass/fastq/ \
--sample_sheet "${WKDIR}"/config/07-ont-wf-human-cnv/wf_human_cnv_sample_sheet.csv \
--fasta "${REF}" \
--genome hg38 \
--bin_size 500 \
--threads "$THREADS" \
--map_threads 24

# move back into otiginal working directory
cd "${WKDIR}"

# Notes:
# EPI2ME Labs workflow for ONT CNV analysis: https://github.com/epi2me-labs/wf-cnv
#  CNV pipeline will run on the basecalled fastq files, it will run an alignment against 
# the provided reference genome, and then perform CNV analysis using QDNAseq.

# there is currently a fun little issue with the CNV pipeline needing a sample sheet
# it also seems to ignore non-compressed fastq files, so run:
# for file in *.fastq ; do 
#   echo -e "... processing $file ...";
#   bgzip "$file";
#   echo -e "... done ...";
# done
# NOTE: it also seems that the gz fastq files have to be in a folder called fastq...

# sample sheet looks like this:
# barcode,sample_id,type
# barcode01,Diabetes_A,AGRF_Diabetes
