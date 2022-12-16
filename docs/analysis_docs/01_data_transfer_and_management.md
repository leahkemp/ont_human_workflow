# 01 - Data transfer and management

Created: 2022/12/12 12:36:19
Last modified: 2022/12/16 13:23:11

- **Aim:** This document outlines how to transfer data off the in house sequencers, backing up data on the dedicated space on production and organising the data
- **Prerequisite software:** [rsync](https://rsync.samba.org/)
- **OS:**

## Table of contents

- [01 - Data transfer and management](#01---data-transfer-and-management)
  - [Table of contents](#table-of-contents)
  - [Transferring data off the in house sequencers and backing up data on production](#transferring-data-off-the-in-house-sequencers-and-backing-up-data-on-production)
    - [In house xavier](#in-house-xavier)
    - [In house gridion](#in-house-gridion)
  - [Organise directory structure](#organise-directory-structure)
  - [Cleanup](#cleanup)

## Transferring data off the in house sequencers and backing up data on production

### In house xavier

The xavier is accessible from the research network

To ssh into the xavier

```bash
# run this code from Leviathan
ssh minit@10.1.91.29
# this will prompt you to enter a password
```

Look at what data is present

```bash
# run this code from the xavier
ls /media/minit/minknow/
```

Transfer to a temporary location on Leviathan, for example to transfer all the sub-directories of `Adipose_AS_ours`

```bash
# run this code from Leviathan
rsync -av minit@10.1.91.29:/media/minit/minknow/Adipose_AS_ours/* /data/Adipose_AS_ours/
```

Then transfer to the dedicated space on production for backing up/storing this data, for example:

```bash
# run this code from Leviathan
rsync -av /data/Adipose_AS_ours/* orac:/NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours/
```

### In house gridion

The gridion is accessible from the production network

To ssh into the gridion

```bash
# run this code from a server on the production network
ssh grid@10.1.30.16
# this will prompt you to enter a password
```

Look at what data is present

```bash
# run this code from the gridion
ls /data/
```

Transfer to the dedicated space on production for backing up/storing this data, for example:

```bash
# run this code from a server on the production network
rsync -av grid@10.1.30.16:/data/Adipose_AS_ours/* /NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours/
```

## Organise directory structure

Follow the established directory structure for the bulk of the data (at `/NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours/`)

<details><summary markdown="span">Current directory structure (click to expand)</summary>

```bash
/NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours
├── [ 110]  AB1052A
│   ├── [  57]  run1
│   ├── [  57]  run2
│   ├── [  57]  run3
│   ├── [  57]  run4
│   └── [  57]  run5
├── [  22]  AB1052B
│   └── [  57]  run6
├── [  26]  AB288B
│   └── [ 469]  p20shear
├── [ 132]  AB526A
│   ├── [  57]  run1
│   ├── [  57]  run2
│   ├── [  57]  run3
│   ├── [  57]  run4
│   ├── [  57]  run5
│   └── [  57]  run6
├── [ 140]  AB526B
│   ├── [  57]  run1
│   ├── [  57]  run2
│   ├── [  52]  run2b_testas
│   ├── [  57]  run3
│   ├── [  57]  run4
│   └── [  57]  run5
├── [  66]  AB740A
│   ├── [  52]  run1
│   ├── [  52]  run2
│   └── [  52]  run3
├── [ 116]  AB740B
│   ├── [  57]  run2
│   ├── [  52]  run3
│   ├── [  52]  run4
│   ├── [  52]  run5
│   └── [  52]  testasgrid
├── [  66]  AB755A
│   ├── [  52]  run1
│   ├── [  52]  run2
│   └── [  52]  run3
├── [  44]  AB755B
│   ├── [  52]  run1
│   └── [  57]  run2
├── [  66]  AB792A
│   ├── [  52]  run1
│   ├── [  52]  run2
│   └── [  57]  run3
├── [ 110]  AB792B
│   ├── [  52]  run1
│   ├── [  52]  run2
│   ├── [  52]  run3
│   ├── [  52]  run4
│   └── [  52]  run5
├── [  66]  OM1052A
│   ├── [  52]  run1
│   ├── [  52]  run2
│   └── [  52]  run3
└── [ 110]  OM1052B
    ├── [  52]  run1
    ├── [  52]  run2
    ├── [  52]  run3
    ├── [  52]  run4
    └── [  57]  run5

61 directories, 0 files
```

</details>
<br/>

The same directory structure is followed for the RRMS data at `/NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_RRMS/`

<details><summary markdown="span">Current directory structure (click to expand)</summary>

```bash
/NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_RRMS/
├── [  66]  AB740B
│   ├── [  52]  run1
│   ├── [  52]  run2
│   └── [  52]  run3
├── [  66]  AB755B
│   ├── [  52]  run1
│   ├── [  52]  run2
│   └── [  52]  run3
├── [  66]  OM1052A
│   ├── [  52]  run1
│   ├── [  52]  run2
│   └── [  52]  run3
└── [  22]  OM1052B
    └── [  52]  run1

14 directories, 0 files
```

</details>
<br/>

## Cleanup

Once the data is transferred off the in house sequencers and organised, remember to cleanup

Cleanup temporary files on Leviathan (if produced) and raw sequencing data on the xavier/gridion. For example:

```bash
# run this code from Leviathan
rm -rf /data/Adipose_AS_ours/

# run this code from the gridion
rm -rf /data/Adipose_AS_ours/

# run this code from the xavier
rm -rf /media/minit/minknow/Adipose_AS_ours/
```

**ONLY RUN THIS ONCE YOU'RE CERTAIN THE DATA IS SUCCESSFULLY BACKED UP - otherwise bye bye data - check several times for typos because humans always make mistakes**
