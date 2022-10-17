#!/bin/bash -l

# conda
conda activate whatshap

# define variables
WKDIR='/work/ont/WGS'
SAMPLE='PBXP289487'
REFERENCE='/work/ont/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta'
OUTPUT='results'

# move to working dir
cd ${WKDIR}/${SAMPLE}
mkdir cutesv_tmp

# cuteSV processing
cuteSV -t 16 \
  --max_cluster_bias_INS 100 \
  --diff_ratio_merging_INS 0.3 \
  --max_cluster_bias_DEL 100 \
  --diff_ratio_merging_DEL 0.3 \
  ./bam/${SAMPLE}_sorted_merged.hp.bam \
  ${REFERENCE} \
  ${OUTPUT}/${SAMPLE}_sv_cutesv.vcf \
  ./cutesv_tmp

# Notes:
# this step is for evaluation of another structural variant caller, cuteSV. It's 
# often nice to have the ability to compare results between various tools. As 
# SVs are important to this project this step has been included in the process.
# For other projects it may well be enough to stop after processing step 06.
# This process outputs a vcf file with the structural variation recorded per
# line.