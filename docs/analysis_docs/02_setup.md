# 02 - Setup

Created: 2022/12/12 12:51:38
Last modified: 2023/03/06 15:36:24

- **Aim:** This document outlines the setup for running the "pipeline" module scripts on ESR's production network
- **OS:** ORAC (CentOS Linux) (ESR production network)

## Table of contents

- [02 - Setup](#02---setup)
  - [Table of contents](#table-of-contents)
  - [Get software dependencies](#get-software-dependencies)
  - [Clone the project repository](#clone-the-project-repository)
  - [Get input files](#get-input-files)
  - [Configure all user configurable parameters](#configure-all-user-configurable-parameters)
  - [Get data](#get-data)

## Get software dependencies

Get or ensure you have the appropriate software dependencies, what we need:

- [git](https://git-scm.com/) (validated to work with v1.8.3.1)
- [guppy]() (validated to work with v6.4.2)
- [conda](https://docs.conda.io/en/latest/) (validated to work with v23.1.0)
- [mamba](https://mamba.readthedocs.io/en/latest/index.html) (validated to work with v1.3.1)
- [GNU coreutils](https://www.gnu.org/software/coreutils/) (validated to work with v8.22)
- [rsync](https://rsync.samba.org/) (validated to work with v3.1.2)
- [slurm](https://slurm.schedmd.com/overview.html) (validated to work with v20.11.6)

----

**All this software should be readily available on the ESR production network, except for conda and mamba which can be installed to a users account**

----

How to check if git is installed and available:

```bash
git --version
```

<details><summary markdown="span">Example output indicating the software is installed and available (click to expand)</summary>

```bash
git version 1.8.3.1
```

</details>
<br/>

How to check if guppy is installed and available:

```bash
/opt/admin/dsc/guppy-gpu/6.4.2/ont-guppy/bin/guppy_basecaller --version
```

<details><summary markdown="span">Example output indicating the software is installed and available (click to expand)</summary>

```bash
: Guppy Basecalling Software, (C) Oxford Nanopore Technologies plc. Version 6.4.2+97a7f06, minimap2 version 2.24-r1122

Use of this software is permitted solely under the terms of the end user license agreement (EULA).
By running, copying or accessing this software, you are demonstrating your acceptance of the EULA.
The EULA may be found in /opt/admin/dsc/guppy-gpu/6.4.2/ont-guppy/bin
```

</details>
<br/>

How to check if conda/mamba is installed and available:

```bash
mamba --version
```

<details><summary markdown="span">Example output indicating the software is installed and available (click to expand)</summary>

```bash
mamba 1.3.1
conda 22.11.1
```

</details>
<br/>

If not installed, see the installation instructions for [conda](https://conda.io/projects/conda/en/latest/user-guide/install/linux.html#installing-on-linux) and [mamba](https://mamba.readthedocs.io/en/latest/installation.html)

How to check if GNU coreutils is installed and available:

```bash
ls --version
```

<details><summary markdown="span">Example output indicating the software is installed and available (click to expand)</summary>

```bash
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Mike Parker, David MacKenzie, and Jim Meyering.
```

</details>
<br/>

How to check if rsync is installed and available:

```bash
rsync --version
```

<details><summary markdown="span">Example output indicating the software is installed and available (click to expand)</summary>

```bash
rsync  version 3.1.2  protocol version 31
Copyright (C) 1996-2015 by Andrew Tridgell, Wayne Davison, and others.
Web site: http://rsync.samba.org/
Capabilities:
    64-bit files, 64-bit inums, 64-bit timestamps, 64-bit long ints,
    socketpairs, hardlinks, symlinks, IPv6, batchfiles, inplace,
    append, ACLs, xattrs, iconv, symtimes, prealloc

rsync comes with ABSOLUTELY NO WARRANTY.  This is free software, and you
are welcome to redistribute it under certain conditions.  See the GNU
General Public Licence for details.
```

</details>
<br/>

How to check if slurm is installed and available:

```bash
sbatch --version
```

<details><summary markdown="span">Example output indicating the software is installed and available (click to expand)</summary>

```bash
slurm 20.11.6
```

</details>
<br/>

## Clone the project repository

The "pipeline" we're running is held in the github repository at https://github.com/leahkemp/ont_human_workflow. We need to clone this repository to get all the code to run the "pipeline". This only needs to be done once.

Navigate to the working directory, if running on ESR's production network, I'd suggest using the dedicated analysis space for human genomics, for example:

```bash
cd /NGS/humangenomics/active/2022/run/
```

Clone the github repository

```bash
git clone https://github.com/leahkemp/ont_human_workflow.git
```

Navigate in to the local git repo

```bash
cd ont_human_workflow
```

## Get input files

We need a reference human genome for this "pipeline", so we will download one from [NCBI](https://www.ncbi.nlm.nih.gov/genome/guide/human/). This only needs to be done once.

```bash
# get reference genome
wget https://www.encodeproject.org/files/GRCh38_no_alt_analysis_set_GCA_000001405.15/@@download/GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz

# un-compress (required for some tools in pipeline such as whatshap)
gunzip GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta.gz

# index
mamba env create \
--yes \
-f ./scripts/envs/conda.samtools.1.16.1.yml

conda activate ~/micromamba/envs/samtools.1.16.1

samtools faidx GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta
```

We also need the bed file defining the tandem repeat regions. This only needs to be done once.

```bash
wget https://github.com/fritzsedlazeck/Sniffles/raw/master/annotations/human_GRCh38_no_alt_analysis_set.trf.bed
```

## Configure all user configurable parameters

We need to configure some variables in each of the "pipeline" module scripts at [./scripts/module_scripts/](./scripts/module_scripts/).

All bash module script's have modifiable SLURM parameters and bash variables. All are configured appropriately for the ESR production network. The only SLURM variable that should need configuring is the email address to which emails indicating completion or failure of scripts can be sent.

```bash
#SBATCH --mail-user=leah.kemp@esr.cri.nz
```

In terms of bash variables, the only variables that should need configuring is the sample to be analysed and possibly the flow cell and kit used.

```bash
SAMPLE="OM1052A"
FLOWCELL="FLO-MIN106"
KIT="SQK-LSK110"
```

*Note. the flow cell and kit used for sequencing can be found in the final_summary file found alongside the raw sequencing data. For example `/NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours/OM1052A/run1/20221114_0429_X5_FAQ91514_d446fbce/final_summary_FAQ91514_d446fbce_df0aee03.txt`.*

You may also need to configure the bash variable that defines the model used by the `./scripts/module_scripts/03-ont-wf-human-variation-calling.sh` script depending on the flow cell and kit used.

```bash
MODEL="dna_r9.4.1_450bps_hac"
```

You can view the model options and choose the appropriate model for your sequencing run with guppy, for example:

```bash
/opt/admin/dsc/guppy-gpu/6.4.2/ont-guppy/bin/guppy_basecaller --print_workflows
```

## Get data

We want the raw fast5 pass files from all sequencing runs for a given sample in a single directory. The data is stored/backed up at `/NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/` on ESR's production network.

Make a copy of the data in your working directory, for example, the "OM1052A" sample has data from three sequencing runs:

```bash
# make sure you have created your bash variables defining the sample and working directory
SAMPLE="OM1052A"
WKDIR="/NGS/humangenomics/active/2022/run/ont_human_workflow/"

# create directory in our working directory to put all data
mkdir -p "${WKDIR}"/fast5/"${SAMPLE}"/

# copy all pass fast5 data from all sequencing runs into this directory in our working directory
rsync -av /NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours/"${SAMPLE}"/run1/20221114_0429_X5_FAQ91514_d446fbce/fast5_pass/* \
"${WKDIR}"/fast5/"${SAMPLE}"/
rsync -av /NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours/"${SAMPLE}"/run2/20221122_0500_X4_FAQ90706_7bf313c3/fast5_pass/* \
"${WKDIR}"/fast5/"${SAMPLE}"/
rsync -av /NGS/clinicalgenomics/archive/2022/run/raw/adipose_ont_methylation/data/Adipose_AS_ours/"${SAMPLE}"/run3/20221122_2113_X4_FAQ90706_09b178bc/fast5_pass/* \
"${WKDIR}"/fast5/"${SAMPLE}"/
```

<details><summary markdown="span">Partial example raw fast5 files for a single sample (click to expand)</summary>

```bash
/NGS/humangenomics/active/2022/run/ont_human_workflow/fast5/OM1052A
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_0.fast5
├── [ 55M]  FAQ90706_pass_09b178bc_3605de32_1.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_2.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_3.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_4.fast5
├── [ 59M]  FAQ90706_pass_09b178bc_3605de32_5.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_6.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_7.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_8.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_9.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_10.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_11.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_12.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_13.fast5
├── [ 60M]  FAQ90706_pass_09b178bc_3605de32_14.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_15.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_16.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_17.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_18.fast5
.
.
.
├── [ 67M]  FAQ91514_pass_d446fbce_df0aee03_1170.fast5
└── [ 18M]  FAQ91514_pass_d446fbce_df0aee03_1171.fast5

0 directories, 3385 files
```

</details>
<br/>
