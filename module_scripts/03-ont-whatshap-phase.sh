#!/bin/bash -l

# conda
conda activate whatshap
# after looking further into it Guix don't plan to support the direct linking of
# base libs like libz in python virtual environments. I need to think more about
# this issue, but for now conda works.

# define variables
WKDIR='/data/basecalled/thalassemia_tmp/'
SAMPLE='proband'
REFERENCE='/public-data/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna'
OUTPUT='results'

# move to working dir
cd ${WKDIR}/${SAMPLE}

# whatshap phase tagging of bam output
whatshap haplotag \
    --ignore-read-groups \
    --output ./bam/${SAMPLE}_sorted_merged.hp.bam  \
    --reference ${REFERENCE} \
    --ignore-read-groups \
    ${OUTPUT}/all.wf_snp.vcf.gz ./bam/${SAMPLE}_sorted_merged.bam
# index bam
samtools index -@ 16 ./bam/${SAMPLE}_sorted_merged.hp.bam

# conda
conda deactivate

# Notes:
# this step phases the data based on the clair3 output and generates a 
# phased bam file. This contains information assigning reads to each
# haplotype. At this stage the bam is able to loaded into a genome 
# viewer/browser and contains aligned reads, with base modification
# (methylation) information, as well as the haplotype information.