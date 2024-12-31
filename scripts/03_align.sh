#!/bin/bash

INPUT_DIR=$1
OUTPUT_DIR=$2
GENOME_INDEX=$3
THREADS=$4

echo "Starting alignment at $(date)"

# Create pairs file for trimmed reads
find ${INPUT_DIR} -name "*_val_1.fq.gz" | sort > ${OUTPUT_DIR}/logs/trimmed_R1.txt
find ${INPUT_DIR} -name "*_val_2.fq.gz" | sort > ${OUTPUT_DIR}/logs/trimmed_R2.txt
paste ${OUTPUT_DIR}/logs/trimmed_R1.txt ${OUTPUT_DIR}/logs/trimmed_R2.txt > ${OUTPUT_DIR}/logs/trimmed_pairs.txt

# Align reads
while read pair; do
    R1=$(echo $pair | cut -f1)
    R2=$(echo $pair | cut -f2)
    SAMPLE_NAME=$(basename $R1 | sed 's/_val_1.fq.gz//')
    
    # Align with HISAT2
    hisat2 -p ${THREADS} -x ${GENOME_INDEX} \
        -1 $R1 -2 $R2 \
        --summary-file ${OUTPUT_DIR}/logs/${SAMPLE_NAME}.align_stats.txt \
        | samtools sort -@ ${THREADS} -O BAM \
        > ${OUTPUT_DIR}/03_aligned/${SAMPLE_NAME}.sorted.bam

    # Index BAM
    samtools index ${OUTPUT_DIR}/03_aligned/${SAMPLE_NAME}.sorted.bam
    
    # Get alignment stats
    samtools flagstat ${OUTPUT_DIR}/03_aligned/${SAMPLE_NAME}.sorted.bam \
        > ${OUTPUT_DIR}/logs/${SAMPLE_NAME}.flagstat.txt
done < ${OUTPUT_DIR}/logs/trimmed_pairs.txt

echo "Alignment completed at $(date)"