#!/bin/bash

# Configuration
PROJECT_DIR="$(pwd)"
THREADS=96  # Your script uses 96 threads
INPUT_DIR="${PROJECT_DIR}/rawFastq"
OUTPUT_DIR="${PROJECT_DIR}/results"
GENOME_INDEX="/path/to/genome" 
GTF_FILE="/path/to/gtf"     

# Create directory structure
mkdir -p ${OUTPUT_DIR}/{01_fastqc,02_trimmed,03_aligned,04_counts,logs}

# Run each step
bash scripts/01_qc.sh ${INPUT_DIR} ${OUTPUT_DIR} ${THREADS}
bash scripts/02_trim.sh ${INPUT_DIR} ${OUTPUT_DIR} ${THREADS}
bash scripts/03_align.sh ${OUTPUT_DIR}/02_trimmed ${OUTPUT_DIR} ${GENOME_INDEX} ${THREADS}
bash scripts/04_count.sh ${OUTPUT_DIR}/03_aligned ${OUTPUT_DIR} ${GTF_FILE} ${THREADS}
