# Cleanup

Created: 2022/12/12 12:36:19
Last modified: 2022/12/16 13:17:56

- **Aim:** This document outlines how to back up the analyses on the dedicated space on production and cleanup
- **Prerequisite software:** [rsync](https://rsync.samba.org/)
- **OS:**

## Table of contents

- [Cleanup](#cleanup)
  - [Table of contents](#table-of-contents)
  - [Backup analyses and cleanup](#backup-analyses-and-cleanup)

## Backup analyses and cleanup

Minimal analyses will be backed up at `/NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation/`

Directory structure:

```bash
/NGS/clinicalgenomics/archive/2022/results/adipose_ont_methylation
├── [ 106]  Adipose_AS_RRMS
│   ├── [   0]  CNV
│   ├── [   0]  QC
│   ├── [  68]  SV
│   ├── [   0]  bam
│   └── [   0]  methyl
└── [ 106]  Adipose_AS_ours
    ├── [   0]  CNV
    ├── [   0]  QC
    ├── [  68]  SV
    ├── [   0]  bam
    └── [   0]  methyl

12 directories, 0 files
```

Move analyses to be backed up

```bash
rsync -av 
```

Clean up after analysis is confirmed to be backed up, for example for sample OM1052A

```bash
rm -rf /NGS/humangenomics/active/2022/run/ont_human_workflow/results/*/OM1052A/
```

**ONLY RUN THIS ONCE YOU'RE CERTAIN THE DATA IS SUCCESSFULLY BACKED UP - otherwise bye bye data - check several times for typos because humans always make mistakes**
