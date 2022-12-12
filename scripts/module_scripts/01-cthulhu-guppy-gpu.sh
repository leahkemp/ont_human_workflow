#!/bin/bash -l

#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --partition=gpu
#SBATCH --job-name=01-cthulhu-guppy-gpu
#SBATCH --time=36:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 12
#SBATCH --mem 52G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
INPUTDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/data/fast5/"
GUPPYPATH="/opt/admin/dsc/guppy-gpu/6.4.2/ont-guppy/bin/"
CONFIG="dna_r10.4.1_e8.2_400bps_modbases_5mc_cg_sup_prom.cfg"
REF="/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz"
SAMPLE="OM1052A"

# create output directory if it doesn't yet exist
mkdir -p ${WKDIR}/results/01-cthulhu-guppy-gpu/

# run Guppy+Remora+Alignment
"${GUPPYPATH}"./guppy_basecaller \
-c "${CONFIG}" \
-a "${REF}" \
-i "${INPUTDIR}" \
-s "${WKDIR}/results/01-cthulhu-guppy-gpu/" \
--chunks_per_runner 412 \
--recursive \
--device "cuda:0,1" \
--bam_out \
--index
