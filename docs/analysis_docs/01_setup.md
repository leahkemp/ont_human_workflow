# 01 - Setup

Created: 2022/12/12 12:51:38
Last modified: 2022/12/13 13:12:20

- **Aim:** This document outlines the setup for running the "pipeline" module scripts
- **Prerequisite software:**
- **OS:** ORAC (CentOS Linux) (ESR production network)

## Table of contents

- [01 - Setup](#01---setup)
  - [Table of contents](#table-of-contents)
  - [Get software dependencies](#get-software-dependencies)
  - [Clone the project repository](#clone-the-project-repository)
  - [Configure all user configurable parameters](#configure-all-user-configurable-parameters)
  - [Get data](#get-data)

## Get software dependencies

Get or ensure you have the appropriate software dependencies, what we need:

- [git](https://git-scm.com/) (validated to work with v1.8.3.1)
- [guppy]() (validated to work with v6.4.2)
- [conda](https://docs.conda.io/en/latest/) (validated to work with v4.13.0)
- [mamba](https://mamba.readthedocs.io/en/latest/index.html) (validated to work with v0.24.0)
- [GNU coreutils](https://www.gnu.org/software/coreutils/) (validated to work with v8.22)
- [rsync](https://rsync.samba.org/) (validated to work with v3.1.2)

*All this software should be readily available on the ESR production network, except for conda and mamba which can be installed to a users accout*

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
mamba 0.24.0
conda 4.13.0
```

</details>
<br/>

If not installed, see the installation instructions for [mamba]() and [conda]()

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

## Configure all user configurable parameters

We need to configure some variables in each of the "pipeline" module scripts at [./scripts/module_scripts/](./scripts/module_scripts/).

Each bash module script has modifiable SLURM parameters. All are configured appropriately for the ESR production network. The only variable that should need configuring is the email address to which emails indicating completion or failure of scripts can be sent.

```bash
#SBATCH --mail-user=leah.kemp@esr.cri.nz
```

Each bash module script also has modifiable bash variables. Again, all are configured appropriately for the ESR production network and the only variable that should need configuring is the sample to be analysed.

```bash
SAMPLE="OM1052A"
```

## Get data

We want the raw fast5 pass files from all sequencing runs for a given sample in a single directory

<details><summary markdown="span">Partial example raw fast5 files for a single sample (click to expand)</summary>

```bash
/NGS/humangenomics/active/2022/run/ont_human_workflow/data/fast5
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
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_19.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_20.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_21.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_22.fast5
├── [ 76M]  FAQ90706_pass_09b178bc_3605de32_23.fast5
├── [ 84M]  FAQ90706_pass_09b178bc_3605de32_24.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_25.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_26.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_27.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_28.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_29.fast5
├── [ 61M]  FAQ90706_pass_09b178bc_3605de32_30.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_31.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_32.fast5
├── [ 59M]  FAQ90706_pass_09b178bc_3605de32_33.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_34.fast5
├── [ 56M]  FAQ90706_pass_09b178bc_3605de32_35.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_36.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_37.fast5
├── [ 59M]  FAQ90706_pass_09b178bc_3605de32_38.fast5
├── [ 55M]  FAQ90706_pass_09b178bc_3605de32_39.fast5
├── [ 54M]  FAQ90706_pass_09b178bc_3605de32_40.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_41.fast5
├── [ 58M]  FAQ90706_pass_09b178bc_3605de32_42.fast5
├── [105M]  FAQ90706_pass_09b178bc_3605de32_43.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_44.fast5
├── [ 54M]  FAQ90706_pass_09b178bc_3605de32_45.fast5
├── [ 57M]  FAQ90706_pass_09b178bc_3605de32_46.fast5
.
.
.
├── [ 67M]  FAQ91514_pass_d446fbce_df0aee03_1170.fast5
└── [ 18M]  FAQ91514_pass_d446fbce_df0aee03_1171.fast5

0 directories, 3385 files
```

</details>
<br/>
