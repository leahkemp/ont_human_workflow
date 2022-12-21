#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition prod
#SBATCH --job-name=07-ont-wf-human-cnv
#SBATCH --time=24:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 48
#SBATCH --mem 130G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE="OM1052A"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"
REF="/NGS/clinicalgenomics/public_data/encode/GRCh38/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta"

# cleaup old ouputs of this script to avoid writing to file twice
rm -rf "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/

# create output directory if it doesn't yet exist
mkdir -p "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/work/
mkdir -p "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/fastq/

# put fastq files in a single directory named "fastq" - Miles notes the pipeline seems to require this
rsync -av "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/pass/*.fastq "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/fastq/ 

# set the shell to be used by conda for this script (and re-start shell to implement changes)
conda init bash
source ~/.bashrc

# create conda environment with htslib installed (contains bgzip)
mamba env create \
--force \
-f "${WKDIR}"/scripts/envs/conda.htslib.1.10.2.yml

# activate htslib conda environment
conda activate htslib.1.10.2

# compress the fastq files - Miles notes the pipeline seems to require this
for file in "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/fastq/*.fastq ; do 
  echo -e "... processing $file ...";
  bgzip "$file";
  echo -e "... done ...";
done

# create conda environment with nextflow installed
mamba env create \
--force \
-f "${WKDIR}"/scripts/envs/conda.nextflow.22.10.1.yml

# activate nextflow conda environment
conda activate nextflow.22.10.1

# move to working dir
cd "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/

# run copy number variant calling
nextflow run -c "${WKDIR}"/config/07-ont-wf-human-cnv/nextflow.config epi2me-labs/wf-cnv \
-r v0.0.3 \
-w "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/work/ \
-profile singularity \
-with-report \
-with-timeline \
-with-trace \
-resume \
--fastq "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/fastq/  \
--sample_sheet "${WKDIR}"/config/07-ont-wf-human-cnv/wf_human_cnv_sample_sheet.csv \
--fasta "${REF}" \
--genome hg38 \
--bin_size 500 \
--threads 48 \
--map_threads 24

# rename output file with sample name
mv "${WKDIR}"/results/05-ont-methyl-calling/"${SAMPLE}"/mod-counts.cpg.acc.bed \
"${WKDIR}"/results/05-ont-methyl-calling/"${SAMPLE}"/"${SAMPLE}"_mod-counts.cpg.acc.bed

mv "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/output/fastq_wf-cnv-report.html \
"${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/output/"${SAMPLE}"_fastq_wf-cnv-report.html

cd "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/output/qdna_seq/
for file in * ; do mv "$file" "${SAMPLE}_$file" ; done

# move back into original working directory
cd "${WKDIR}"

# Notes:
# EPI2ME Labs workflow for ONT CNV analysis: ht`tps://github.com/epi2me-labs/wf-cnv
# CNV pipeline will run on the basecalled fastq files, it will run an alignment against 
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
