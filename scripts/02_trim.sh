#!/bin/bash

INPUT_DIR=$1
OUTPUT_DIR=$2
THREADS=$3

echo "Starting QC at $(date)"

# Run FastQC
find ${INPUT_DIR} -name "*.fastq.gz" | \
    xargs fastqc -t ${THREADS} -o ${OUTPUT_DIR}/01_fastqc

# Run MultiQC
multiqc -f -o ${OUTPUT_DIR}/01_fastqc ${OUTPUT_DIR}/01_fastqc

# Basic read counts
echo "Initial read counts:" > ${OUTPUT_DIR}/logs/read_counts.log
for fq in ${INPUT_DIR}/*.fastq.gz; do
    echo "$(basename $fq): $(zcat $fq | wc -l)/4" >> ${OUTPUT_DIR}/logs/read_counts.log
done

echo "QC completed at $(date)"