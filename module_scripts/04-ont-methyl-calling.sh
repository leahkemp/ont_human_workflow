#!/bin/bash -l

# conda
conda activate modbam2bed

# define variables
WKDIR='/data/basecalled/thalassemia_tmp/'
SAMPLE='proband'
REFERENCE='/public-data/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna'

# move to working dir
cd ${WKDIR}/${SAMPLE}
mkdir bed

# create methylation bed files
for HP in 1 2; do
    modbam2bed \
        -e -m 5mC --cpg -t 16 --haplotype ${HP} \
        ${REFERENCE} \
        ./bam/${SAMPLE}_sorted_merged.hp.bam \
        | bgzip -c > ./bed/${SAMPLE}_methylation.hp${HP}.cpg.bed.gz
done;

# create an aggregated bed file
modbam2bed \
  -e -m 5mC --cpg --aggregate -t 16 \
  ${REFERENCE} \
  ./bam/${SAMPLE}_sorted_merged.hp.bam \
  | bgzip -c > ./bed/${SAMPLE}_methylation.aggregated.cpg.bed.gz

# Notes:
# this step extracts the methylation information from the bam file, generating
# bed files. There are two processes here, the first creates two bed files, one
# for each haplotype. These are very useful for exploring allele specific methylation.
# The second process generates a single aggragated bed file, it merges the 
# haplotype data to give site specific methylation. It should be noted that this is 
# per strand, so some processing will be required to 'collapse' the data to a
# single CpG site, but this type of work is usually performed in the downstream\
# analysis, using packages such as methylkit.