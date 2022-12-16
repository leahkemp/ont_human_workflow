# ONT human workflow

## General info

Here we are implementing a current best practice workflow for processing human Oxford Nanopore Technologies (ONT) sequencing data implemented by [Miles Benton](https://github.com/sirselim) and the Singapore - New Zealand Applications Project Support Team, [Oxford Nanopore Technologies](https://github.com/nanoporetech). A nextflow pipeline wrapping up these scripts is on the horizon, but since we want to run this code now, this repository serves to adapt the original scripts to run on ESR's production network, including deploying to [SLURM](https://slurm.schedmd.com/overview.html). Running this analysis on other compute infrastructures is not supported by the code/documentation in this repository, but is certainly possible and achievable with some bioinformatics knowledge and bit of legwork. See the original work this repository is based on in the [./docs/original_work/workflow_outline/](./docs/original_work/workflow_outline/) directory.

## Workflow overview

```mermaid
graph TD;
    fast5{fast5 / pod5 / slow5}-->Guppy/Remora/alignment([Guppy + Remora + alignment]);
    Guppy/Remora/alignment-->modbam{bam};
    Guppy/Remora/alignment-->seqsum([sequencing_summary.csv]);
    seqsum-->duplex_tools([duplex-tools]);
    Guppy/Remora/alignment-->fastq{fastq};
    fastq-->duplex_tools;
    fast5-->duplex_tools;
    duplex_tools-->read_pairs([duplex read pairs]);
    read_pairs-->guppy_duplex([guppy_basecaller_duplex]);
    guppy_duplex-->duplex_reads{duplex reads}
    modbam-->Clair3_nextflow;
    GRCh38_ref_genome{reference genome}-->Guppy/Remora/alignment;
    GRCh38_ref_genome{reference genome}-->Clair3_nextflow([wf-human-variation - clair3 + sniffles2]);
    GRCh38_ref_genome{reference genome}-->Whatshap
    modbam{bam}-->Whatshap;
    Whatshap-->modbam_phased{bam - phased};
    Clair3_nextflow-->vcf_phased;
    modbam_phased-->view([genome browser]);
    view-->IGV;
    vcf_phased{vcf}-->Whatshap;
    vcf_phased{vcf}-->variant_annotation([variant annotation]);
    variant_annotation-->VEP;
    variant_annotation-->dbNSFP;
    modbam_phased-->CNV_analysis([CNV analysis]);
    CNV_analysis-->qdna-seq([wf-human-cnv]);
    qdna-seq-->output(report + qdnaseq ouput);
    modbam_phased-->modbam2bed;
    modbam2bed-->mod_bed.gz;
    GRCh38_ref_genome{reference genome}-->modbam2bed;
    mod_bed.gz{bed}-->methylation_analysis([methylation analysis]);
    Clair3_nextflow-->sniffles2([additional SV analysis - cuteSV, SVIM, SVision]);
    GRCh38_ref_genome{reference genome}-->sniffles2;
    Clair3_nextflow-->SV_data;
    sniffles2-->SV_data{SV data};
    SV_data-->SV_vcf.gz{vcf};
    VEP-->annotated_vcf.gz{vcf};
    dbNSFP-->annotated_vcf.gz;
    annotated_vcf.gz-->SNV_indel_analysis([SNV/indel analysis]);
```

## Analysis workflow run this analysis on the ESR production network

- [01 - Data transfer and management](https://github.com/leahkemp/ont_human_workflow/blob/main/docs/analysis_docs/01_data_transfer_and_management.md)
- [02 - Setup](https://github.com/leahkemp/ont_human_workflow/blob/main/docs/analysis_docs/02_setup.md)
- [03 - Run module scripts](https://github.com/leahkemp/ont_human_workflow/blob/main/docs/analysis_docs/03_run_module_scripts.md)
- [04 - Cleanup](https://github.com/leahkemp/ont_human_workflow/blob/main/docs/analysis_docs/04_cleanup.md)

## Access

- The github repository for this project is public
- For other general queries about this project beyond the bioinformatics, contact the current (2022) representatives of the ESR genomics group, Donia Macartney-Coxson (Donia.Macartney-Coxson@esr.cri.nz) and/or Joep de Ligt (joep.deligt@esr.cri.nz)

## Github repository

Find the github repository for this project at: https://github.com/leahkemp/ont_human_workflow
