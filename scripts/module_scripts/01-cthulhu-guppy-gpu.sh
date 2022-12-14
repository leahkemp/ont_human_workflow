#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=gpu
#SBATCH --job-name=01-cthulhu-guppy-gpu
#SBATCH --time=36:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 12
#SBATCH --mem 52G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE="OM1052A"
FLOWCELL="FLO-MIN106"
KIT="SQK-LSK110"
INPUTDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/fast5/OM1052A/"
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
GUPPYPATH="/opt/admin/dsc/guppy-gpu/6.4.2/ont-guppy/bin/"
REF="/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz"

# cleaup old ouputs of this script to avoid writing to file twice
rm -rf ${WKDIR}/results/01-cthulhu-guppy-gpu/${SAMPLE}/

# create output directory if it doesn't yet exist
mkdir -p ${WKDIR}/results/01-cthulhu-guppy-gpu/${SAMPLE}/

# run Guppy+Remora+Alignment
"${GUPPYPATH}"/guppy_basecaller \
--flowcell "${FLOWCELL}" \
--kit "${KIT}" \
--model ${MODEL} \
-a "${REF}" \
-i "${INPUTDIR}" \
-s "${WKDIR}/results/01-cthulhu-guppy-gpu/${SAMPLE}/" \
--chunks_per_runner 412 \
--num_alignment_threads 16 \
--num_base_mod_threads 16 \
--recursive \
--device "cuda:0,1" \
--bam_out \
--index
