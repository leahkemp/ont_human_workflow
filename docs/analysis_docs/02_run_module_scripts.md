# 02 - Run module scripts

Created: 2022/12/12 12:51:47
Last modified: 2022/12/13 13:08:09

- **Aim:** This document outlines the process for running the "pipeline" module scripts
- **Prerequisite software:**
- **OS:** ORAC (CentOS Linux) (ESR production network)

## Table of contents

- [02 - Run module scripts](#02---run-module-scripts)
  - [Table of contents](#table-of-contents)
    - [Run module scripts](#run-module-scripts)

### Run module scripts

Navigate to your working directory

```bash
cd /NGS/humangenomics/active/2022/run/ont_human_workflow/
```

Run each module script in succession, run only one script at a time since some scripts depend on the outputs of earlier scripts

```bash
sbatch ./scripts/module_scripts/01-cthulhu-guppy-gpu.sh

sbatch ./scripts/module_scripts/02-ont-bam-merge.sh

sbatch ./scripts/module_scripts/03-ont-human-variation-calling.sh

sbatch ./scripts/module_scripts/04-ont-whatshap-phase.sh

sbatch ./scripts/module_scripts/05-ont-methyl-calling.sh

sbatch ./scripts/module_scripts/06-ont-sv-cutesv.sh

sbatch ./scripts/module_scripts/07-ont-wf-human-cnv.sh
```
