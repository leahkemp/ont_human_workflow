
Get test data and unzip

```bash
cd /NGS/humangenomics/active/2022/run/ont_human_workflow/data/

wget -O demo_data.tar.gz \
https://ont-exd-int-s3-euwst1-epi2me-labs.s3.amazonaws.com/wf-human-variation/demo_data.tar.gz

tar -xzvf demo_data.tar.gz

rm demo_data.tar.gz
```

Check data downloaded without corruption

```bash
cd ./demo_data/
md5sum -c md5sums.txt
```

Create conda environment with nextflow installed

```bash
cd /NGS/humangenomics/active/2022/run/ont_human_workflow/
mamba env create -f ./envs/conda.nextflow.22.10.0.yml
conda activate nextflow
```

Test nextflow and pipeline

```bash
nextflow run epi2me-labs/wf-human-variation --help
```

Move input bam to expected place for workflow

```bash
mkdir -p /NGS/humangenomics/active/2022/run/ont_human_workflow/bam/

cp /NGS/humangenomics/active/2022/run/ont_human_workflow/data/demo_data/demo.bam \
/NGS/humangenomics/active/2022/run/ont_human_workflow/bam/demo_sorted_merged.bam

cp /NGS/humangenomics/active/2022/run/ont_human_workflow/data/demo_data/demo.bam.bai \
/NGS/humangenomics/active/2022/run/ont_human_workflow/bam/demo_sorted_merged.bam.bai
```

Get claire3 models

```bash
cd /NGS/clinicalgenomics/public_data/
mkdir -p clair3_models
wget http://www.bio8.cs.hku.hk/clair3/clair3_models/clair3_models.tar.gz
tar -xvf clair3_models.tar.gz --directory clair3_models
rm clair3_models.tar.gz
```
