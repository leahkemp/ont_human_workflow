# 04 - Cleanup

Created: 2022/12/12 12:36:19
Last modified: 2022/12/21 16:04:39

- **Aim:** This document outlines how to back up the analyses on the dedicated space on production and cleanup
- **Prerequisite software:** [rsync](https://rsync.samba.org/)
- **OS:**

## Table of contents

- [04 - Cleanup](#04---cleanup)
  - [Table of contents](#table-of-contents)
  - [Backup analyses and cleanup](#backup-analyses-and-cleanup)

## Backup analyses and cleanup

Minimal analyses will be backed up at `/NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/`

Directory structure:

```bash
/NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/
├── [ 127]  Adipose_AS_RRMS
│   ├── [   0]  CNV
│   ├── [   0]  QC
│   ├── [   0]  SNP
│   ├── [  68]  SV
│   ├── [   0]  bam
│   └── [   0]  methyl
└── [ 127]  Adipose_AS_ours
    ├── [ 503]  CNV
    ├── [ 149]  QC
    ├── [  82]  SNP
    ├── [  68]  SV
    ├── [  96]  bam
    └── [ 211]  methyl

14 directories, 0 files
```

Move analyses to be backed up, for example for sample OM1052A for the "Adipose_AS_ours" sequencing

```bash
# make sure you have created your bash variables defining the sample and working directory
SAMPLE="OM1052B"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"

# bams
rsync -av "${WKDIR}"/results/04-ont-whatshap-phase/"${SAMPLE}"/* /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/bam/

# snp
rsync -av "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/"${SAMPLE}".wf_snp.vcf.gz* /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/SNP/

# sv
rsync -av "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/"${SAMPLE}".wf_sv.vcf.gz* /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/SV/wf-human-variation-calling/
rsync -av "${WKDIR}"/results/06-ont-sv-cutesv/"${SAMPLE}"/"${SAMPLE}"_sv_cutesv.vcf.gz* /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/SV/cutesv/

# methylation
rsync -av "${WKDIR}"/results/05-ont-methyl-calling/"${SAMPLE}"/* /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/methyl/

# CNV
rsync -av "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/output/qdna_seq/* /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/CNV/

# QC
rsync -av "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/"${SAMPLE}".wf-human-snp-report.html /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/QC/
rsync -av "${WKDIR}"/results/03-ont-wf-human-variation-calling/"${SAMPLE}"/"${SAMPLE}".wf-human-sv-report.html /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/QC/
rsync -av "${WKDIR}"/results/07-ont-wf-human-cnv/"${SAMPLE}"/output/"${SAMPLE}"_fastq_wf-cnv-report.html /NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/Adipose_AS_ours/QC/
```

Clean up after analysis is confirmed to be backed up

```bash
rm -rf "${WKDIR}"/results/*/"${SAMPLE}"/
rm -rf "${WKDIR}"/fast5/"${SAMPLE}"/
```

**ONLY RUN THIS ONCE YOU'RE CERTAIN THE DATA IS SUCCESSFULLY BACKED UP - otherwise bye bye data - check several times for typos because humans always make mistakes**
