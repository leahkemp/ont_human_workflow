#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=gpu
#SBATCH --job-name=01-ont-guppy-gpu
#SBATCH --time=36:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 12
#SBATCH --mem 52G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE="OM1052A"
FLOWCELL="FLO-MIN106"
KIT="SQK-LSK110"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"
GUPPYPATH="/opt/admin/dsc/guppy-gpu/6.4.2/ont-guppy/bin/"
REF="/NGS/clinicalgenomics/public_data/encode/GRCh38/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta"

# cleaup old ouputs of this script to avoid writing to file twice
rm -rf "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/

# create output directory if it doesn't yet exist
mkdir -p "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/

# move to working dir
cd "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/

# run Guppy+Remora+Alignment
"${GUPPYPATH}"/guppy_basecaller \
--flowcell "${FLOWCELL}" \
--kit "${KIT}" \
-a "${REF}" \
-i "${WKDIR}"/fast5/"${SAMPLE}"/ \
-s "${WKDIR}"/results/01-ont-guppy-gpu/"${SAMPLE}"/ \
--chunks_per_runner 412 \
--num_alignment_threads 16 \
--num_base_mod_threads 16 \
--recursive \
--device "cuda:0,1" \
--bam_out \
--index

# move back into original working directory
cd "${WKDIR}"
