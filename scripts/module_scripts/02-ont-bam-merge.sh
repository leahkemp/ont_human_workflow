#!/bin/bash -l

#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=leah.kemp@esr.cri.nz
#SBATCH --partition prod
#SBATCH --job-name=01-ont-bam-merge
#SBATCH --time=24:00:00
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --mem 64G
#SBATCH --output="./logs/slurm-%j-%x.out"

# define variables
WKDIR='/NGS/humangenomics/active/2022/run/ont_human_workflow/'
SAMPLE="demo"

# make bam dir and move to working dir
mkdir ${WKDIR}/${SAMPLE}/bam
cd ${WKDIR}/${SAMPLE}

# set a soft ulimt (number of open files)
ulimit -n 6000

# bamtools
ls ${WKDIR}/results/00-cthulhu-guppy-gpu/basecalled/pass/*.bam > ${WKDIR}/results/00-cthulhu-guppy-gpu/bam/bam_list.txt

# create conda environment with bamtools installed and activate it
mamba env create --force -f ${WKDIR}/scripts/envs/conda.bamtools.2.5.2.yml
conda activate bamtools

# merge bams
bamtools merge -list ${WKDIR}/results/00-cthulhu-guppy-gpu/bam/bam_list.txt -out ${WKDIR}/results/00-cthulhu-guppy-gpu/bam//${SAMPLE}_merged.bam

# create conda environment with sambamba installed and activate it
mamba env create --force -f ${WKDIR}/scripts/envs/conda.sambamba.0.8.2.yml
conda activate sambamba

# sort and index bams
sambamba sort -m 64GB -t 12 ${WKDIR}/results/00-cthulhu-guppy-gpu/bam/${SAMPLE}_merged.bam -o ${WKDIR}/results/00-cthulhu-guppy-gpu/bam/${SAMPLE}_sorted_merged.bam
sambamba index -t 12 ${WKDIR}/results/00-cthulhu-guppy-gpu/bam/${SAMPLE}_sorted_merged.bam
