# README

Here we are implementing a generic workflow for processing ONT sequencing data based on the work Miles Benton and the Singapore - New Zealand Applications Project Support Team, Oxford Nanopore Technologies put together. This involves adapting the original scripts to run on ESR's production network, including deploying to slurm. See the original work this repository is based on in the [./docs/original_work/workflow_outline/](./docs/original_work/workflow_outline/) directory.

---

To get started analysing data with this "pipeline" on ESR's production network, see [./docs/analysis_docs/](./docs/analysis_docs/). Running this analysis on other compute infrastructures is not supported by the code/documentation in this repository, but is certainly possible and achievable with some bioinformatics knowledge.

---

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
