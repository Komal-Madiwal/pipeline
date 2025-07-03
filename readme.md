# NGS Analysis Pipeline for Paired-End Data (HPC SLURM)

This pipeline shows how to run NGS analysis of **paired-end sequencing data** on a **High Performance Computing (HPC)** system using a **SLURM job script**.

It performs the following steps:
1. **Quality Control** – using FastQC  
2. **Trimming** – using Trimmomatic  
3. **Alignment** – using BWA  
4. **Conversion to BAM** – using Samtools

```
## Folder Structure
.
├── input
│   ├── SRR29766486_1.fastq
│   └── SRR29766486_2.fastq
├── ngs_analysis.err
├── ngs_analysis.out
├── ngs_analysis.sh
├── output
│   ├── bwa
│   │   ├── SRR29766486.bam
│   │   └── SRR29766486.sam
│   ├── fastqc
│   │   ├── SRR29766486_1_fastqc.html
│   │   ├── SRR29766486_1_fastqc.zip
│   │   ├── SRR29766486_2_fastqc.html
│   │   └── SRR29766486_2_fastqc.zip
│   └── trimm
│       ├── SRR29766486_T_1.fastq
│       ├── SRR29766486_T_2.fastq
│       ├── SRR29766486_U_1.fastq
│       └── SRR29766486_U_2.fastq
├── readme.md
└── reference
    ├── reference.fasta
    ├── reference.fasta.amb
    ├── reference.fasta.ann
    ├── reference.fasta.bwt
    ├── reference.fasta.pac
    └── reference.fasta.sa
```

## How to Run

To run the SLURM job on HPC, use:

```bash
sbatch ngs_analysis.sh
