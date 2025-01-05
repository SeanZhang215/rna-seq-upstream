# RNA-seq Upstream Analysis Pipeline

A streamlined pipeline for processing RNA sequencing data, focusing on basic upstream analysis steps.

## Overview

This pipeline performs:
- Quality control with FastQC/MultiQC
- Adapter and quality trimming with Trim Galore
- Alignment using HISAT2
- Gene counting with featureCounts

## Installation

Install conda if not yet. Then create the environment:
```bash
conda env create -f environment.yaml
conda activate rnaseq
```

## Directory Setup

Place the raw fastq files in a directory called `rawFastq/` before running the pipeline:
```bash
project_dir/
├── rawFastq/        
├── run_pipeline.sh
├── scripts/
│   ├── 01_qc.sh
│   ├── 02_trim.sh  
│   ├── 03_align.sh
│   └── 04_count.sh
├── environment.yaml
└── README.md
```

## Usage

After configuration:
```bash
chmod +x run_pipeline.sh scripts/*.sh
./run_pipeline.sh
```

## Output Structure

```
results/
├── 01_fastqc/      # FastQC and MultiQC reports
├── 02_trimmed/     # Trimmed fastq files
├── 03_aligned/     # BAM files
├── 04_counts/      # Count matrix
└── logs/           # Pipeline logs and QC metrics
```


## Dependencies

All dependencies are handled through the conda environment:
- Python 3.8
- FastQC 0.11.9
- MultiQC 1.12
- Trim Galore 0.6.7
- HISAT2 2.2.1
- Samtools 1.15
- Subread 2.0.1
