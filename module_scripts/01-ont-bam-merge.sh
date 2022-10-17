#!/bin/bash -l

# define variables
WKDIR='/data/basecalled/thalassemia_tmp/'
SAMPLE='proband'

# make bam dir and move to working dir
mkdir ${WKDIR}/${SAMPLE}/bam
cd ${WKDIR}/${SAMPLE}

# set a soft ulimt (number of open files)
ulimit -n 6000

# bamtools
ls basecalled/pass/*.bam > ./bam/bam_list.txt
bamtools merge -list ./bam/bam_list.txt -out ./bam/${SAMPLE}_merged.bam
sambamba sort -m 64GB -t 12 ./bam/${SAMPLE}_merged.bam -o ./bam/${SAMPLE}_sorted_merged.bam
sambamba index -t 12 ./bam/${SAMPLE}_sorted_merged.bam

# Notes:
# 