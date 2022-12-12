# 01 - Setup

Created: 2022/12/12 12:51:38
Last modified: 2022/12/12 13:16:28

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
- [conda](https://docs.conda.io/en/latest/) (validated to work with v4.13.0) - can be installed to a users account
- [mamba](https://mamba.readthedocs.io/en/latest/index.html) (validated to work with v0.24.0) - can be installed to a users account
- [GNU coreutils](https://www.gnu.org/software/coreutils/) (validated to work with v8.22) - should be readily available on the ESR production network

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

## Clone the project repository

## Configure all user configurable parameters

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
