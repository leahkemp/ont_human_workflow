#!/bin/bash -l

# define sample to process
INPUTDIR="/data/basecalled/thalassemia_tmp/proband/fast5/"
OUTPUTDIR="/data/basecalled/thalassemia_tmp/proband/basecalled/"
GUPPYPATH="/public-data/software/guppy/6.3.4/ont-guppy/bin/"
CONFIG="dna_r9.4.1_450bps_modbases_5hmc_5mc_cg_sup.cfg"
REF="/public-data/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"

# Run Guppy+Remora+Alignment - check paths and parameters are correct
"${GUPPYPATH}"./guppy_basecaller \
  -c "${CONFIG}" \
  -a "${REF}" \
  -i "${INPUTDIR}" \
  -s "${OUTPUTDIR}" \
  --chunks_per_runner 412 \
  --recursive \
  --device "cuda:0,1" \
  --bam_out \
  --index

# define sample to process
INPUTDIR="/data/basecalled/thalassemia_tmp/proband/test/"
OUTPUTDIR="/data/basecalled/thalassemia_tmp/proband/test/guppy6.3.4/"
GUPPYPATH="/public-data/software/guppy/6.3.4/ont-guppy/bin/"
CONFIG="dna_r9.4.1_450bps_modbases_5hmc_5mc_cg_sup.cfg"
REF="/public-data/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"

# Run Guppy+Remora+Alignment - check paths and parameters are correct
"${GUPPYPATH}"./guppy_basecaller \
  -c "${CONFIG}" \
  -a "${REF}" \
  -i "${INPUTDIR}" \
  -s "${OUTPUTDIR}" \
  --chunks_per_runner 412 \
  --recursive \
  --device "cuda:0,1" \
  --bam_out \
  --index

SAMPLE="guppy6.3.4"

ls *.bam > bam_list.txt
bamtools merge -list bam_list.txt -out ${SAMPLE}_merged.bam
sambamba sort -m 64GB -t 12 ${SAMPLE}_merged.bam -o ${SAMPLE}_sorted_merged.bam
sambamba index -t 12 ${SAMPLE}_sorted_merged.bam

samtools view -@ 4 -F 2308 -o ${SAMPLE}_sorted_merged_filtered.bam ${SAMPLE}_sorted_merged.bam
