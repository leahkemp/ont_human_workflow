#!/bin/bash -l

# define variables
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
SAMPLE='proband'
MODEL='/public-data/software/clair3/models/ont_guppy5'
REFERENCE='/public-data/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna'
TDREPETS='/public-data/references/GRCh38/human_GRCh38_no_alt_analysis_set.trf.bed'
OUTPUT='results'
NFCONFIG='/public-data/configs/nextflow_local_overide.config'
# note: created an overide config to provide modified CPU and Memory values
# change these values if you want to tweak performance based on resources

# move to working dir
cd ${WKDIR}/${SAMPLE}
mkdir results

# run Clair3 variant calling and sniffles2
nextflow -c ${NFCONFIG} run epi2me-labs/wf-human-variation \
  -resume \
  --threads 24 \
  -profile standard,local \
  --snp --sv \
  --phase_vcf \
  --use_longphase \
  --tr_bed ${TDREPETS} \
  --model ${MODEL} \
  --bam ./bam/${SAMPLE}_sorted_merged.bam \
  --ref ${REFERENCE} \
  --out_dir ${OUTPUT}

# Notes:
# This step calls the ONT wf-human-variation nextflow pipeline
# (https://github.com/epi2me-labs/wf-human-variation), which performs variant calling (clair3),
# phase marking, and structural variant calling using sniffles2 (sniffles2 was a seperate step
# previously). 