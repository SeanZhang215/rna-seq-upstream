#!/bin/bash

INPUT_DIR=$1
OUTPUT_DIR=$2
GTF_FILE=$3
THREADS=$4

echo "Starting counting at $(date)"

# Run featureCounts
featureCounts -T ${THREADS} \
    -p \
    -t exon \
    -g gene_id \
    -a ${GTF_FILE} \
    -o ${OUTPUT_DIR}/04_counts/counts.txt \
    ${INPUT_DIR}/*.sorted.bam \
    2> ${OUTPUT_DIR}/logs/featureCounts.log

# Generate simple count statistics
echo "Counting statistics:" > ${OUTPUT_DIR}/logs/counting_stats.log
cut -f1,7- ${OUTPUT_DIR}/04_counts/counts.txt | \
    awk 'NR>2{for(i=2;i<=NF;i++) t+=$i; print "Total counts: "t; t=0}' \
    >> ${OUTPUT_DIR}/logs/counting_stats.log

echo "Counting completed at $(date)"