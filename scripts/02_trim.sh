#!/bin/bash

INPUT_DIR=$1
OUTPUT_DIR=$2
THREADS=$3

echo "Starting trimming at $(date)"

# Create pairs file
find ${INPUT_DIR} -name "*_R1_001.fastq.gz" | sort > ${OUTPUT_DIR}/logs/R1.txt
find ${INPUT_DIR} -name "*_R2_001.fastq.gz" | sort > ${OUTPUT_DIR}/logs/R2.txt
paste ${OUTPUT_DIR}/logs/R1.txt ${OUTPUT_DIR}/logs/R2.txt > ${OUTPUT_DIR}/logs/pairs.txt

# Trim reads
while read pair; do
    R1=$(echo $pair | cut -f1)
    R2=$(echo $pair | cut -f2)
    
    trim_galore -q 25 --phred33 --length 20 -e 0.1 \
        --stringency 3 --paired \
        -o ${OUTPUT_DIR}/02_trimmed \
        --cores ${THREADS} \
        $R1 $R2
done < ${OUTPUT_DIR}/logs/pairs.txt

# Log trimming stats
echo "Post-trimming read counts:" > ${OUTPUT_DIR}/logs/trimming_stats.log
for fq in ${OUTPUT_DIR}/02_trimmed/*_val_*.fq.gz; do
    echo "$(basename $fq): $(zcat $fq | wc -l)/4" >> ${OUTPUT_DIR}/logs/trimming_stats.log
done

echo "Trimming completed at $(date)"
