#!/bin/sh

# SLURM script for NGS analysis pipeline on HPC

#SBATCH --job-name=ngs_analysis         # Name of the job
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks=1                      # Number of tasks
#SBATCH --cpus-per-task=1               # Number of CPU cores per task
#SBATCH --partition=cpu-debug           # Partition/queue to run the job
#SBATCH --output=ngs_analysis.out       # Standard output file
#SBATCH --error=ngs_analysis.err        # Standard error file

# Load necessary bioinformatics modules
module load fastqc-0.12.0 
module load Trimmomatic-0.39 
module load bwa-0.7.17
module load samtools-1.20 

# Define paths and sample name
SAMPLE="SRR29766486"
HOME_DIR=$(pwd)
INPUT_DIR="${HOME_DIR}/input"
OUTPUT_DIR="${HOME_DIR}/output"
QC_OUTPUT="${OUTPUT_DIR}/fastqc"
TRIMMED_DIR="${OUTPUT_DIR}/trimm"
ALIGNMENT_DIR="${OUTPUT_DIR}/bwa"
REF_FASTA="${HOME_DIR}/reference/reference.fasta"

# Define input/output FASTQ and alignment files
FASTQ_R1="${SAMPLE}_1.fastq"
FASTQ_R2="${SAMPLE}_2.fastq"
FASTQ_TRIMMED_R1="${TRIMMED_DIR}/${SAMPLE}_T_1.fastq"
FASTQ_UNPAIRED_R1="${TRIMMED_DIR}/${SAMPLE}_U_1.fastq"
FASTQ_TRIMMED_R2="${TRIMMED_DIR}/${SAMPLE}_T_2.fastq"
FASTQ_UNPAIRED_R2="${TRIMMED_DIR}/${SAMPLE}_U_2.fastq"
SAM_OUTPUT="${ALIGNMENT_DIR}/${SAMPLE}.sam"
BAM_OUTPUT="${ALIGNMENT_DIR}/${SAMPLE}.bam"
SORTED_BAM="${ALIGNMENT_DIR}/${SAMPLE}.sorted.bam"

# Create output directories if they don't exist
echo "Creating output directories..."
mkdir -p ${OUTPUT_DIR} ${QC_OUTPUT} ${TRIMMED_DIR} ${ALIGNMENT_DIR}

# Step 1: Perform quality control with FastQC
echo "Running FastQC..."
fastqc ${INPUT_DIR}/${FASTQ_R1} ${INPUT_DIR}/${FASTQ_R2} -o ${QC_OUTPUT}

# Step 2: Trim low-quality bases and adapters using Trimmomatic
echo "Running Trimmomatic..."
trimmomatic PE -phred33  \
  ${INPUT_DIR}/${FASTQ_R1} ${INPUT_DIR}/${FASTQ_R2} \
  ${FASTQ_TRIMMED_R1} ${FASTQ_UNPAIRED_R1} \
  ${FASTQ_TRIMMED_R2} ${FASTQ_UNPAIRED_R2} \
  LEADING:3 TRAILING:3 MINLEN:36

# Step 3: Index the reference genome using BWA
echo "Indexing reference genome..."
bwa index ${REF_FASTA}

# Step 4: Align paired-end reads to reference genome using BWA-MEM
echo "Running BWA MEM alignment..."
bwa mem ${REF_FASTA} ${FASTQ_TRIMMED_R1} ${FASTQ_TRIMMED_R2} > ${SAM_OUTPUT}

# Step 5: Convert SAM to BAM format using Samtools
echo "Converting SAM to BAM..."
samtools view -bS ${SAM_OUTPUT} > ${BAM_OUTPUT}