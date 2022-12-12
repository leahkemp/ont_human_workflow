#!/bin/bash -l

#SBATCH --nodelist=KSCPROD-DATA2
#SBATCH --job-name=01-cthulhu-guppy-gpu
#SBATCH --time=36:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 12
#SBATCH --mem 52G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
INPUTDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/data/fast5/"
GUPPYPATH="/opt/bioinf/guppy/6.0.1/ont-guppy-cpu/bin/"
CONFIG="dna_r9.4.1_450bps_modbases_5hmc_5mc_cg_sup.cfg"
REF="/NGS/clinicalgenomics/public_data/ncbi/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz"
SAMPLE="OM1052A"

# create output directory if it doesn't yet exist
mkdir ${WKDIR}/results/01-cthulhu-guppy-gpu/

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
