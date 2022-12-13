#!/bin/bash -l

#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --partition prod
#SBATCH --job-name=02-ont-bam-merge
#SBATCH --time=00:30:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --mem 64G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
SAMPLE="OM1052A"
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'

# cleaup old ouputs of this script to avoid writing to file twice
rm -rf ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/

# create output directory if it doesn't yet exist
mkdir -p ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/

# create list of bam files to merge
ls ${WKDIR}/results/01-cthulhu-guppy-gpu/${SAMPLE}/pass/*.bam > ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_bam_list.txt

# create conda environment with bamtools installed
mamba env create \
--force \
-f ${WKDIR}/scripts/envs/conda.bamtools.2.5.2.yml

# activate bamtools conda environment
conda activate bamtools.2.5.2

# merge bams
bamtools merge \
-list ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_bam_list.txt \
-out ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_merged.bam

# create conda environment with sambamba installed
mamba env create \
--force \
-f ${WKDIR}/scripts/envs/conda.sambamba.0.8.2.yml

# activate sambamba conda environment
conda activate sambamba.0.8.2

# sort bams
sambamba sort \
-m 64GB \
-t 12 \
${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_merged.bam \
-o ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_merged_sorted.bam

# index bams
sambamba index \
-t 12 \
${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_merged_sorted.bam

# cleanup uneeded files
rm ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_bam_list.txt
rm ${WKDIR}/results/02-ont-bam-merge/${SAMPLE}/${SAMPLE}_merged.bam
