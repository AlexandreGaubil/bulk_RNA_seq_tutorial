# bulk RNA sequencing work flow

Work flow for bulk RNA sequencing

## Table of content
* Overview
* Contributors
* Workflow

## Overview
This this the general description of the RNA seq workflow. The repository is organized in several folders correspond to different steps of RNA seq
* FastQC: initial quality control
* STAR : read alignment to the genome
* SAMTools: sorting, filtering and indexing bam/sam files after alignment
* featureCounts: count number of transcripts and assign them to features(genes)
* DeSeq2: differential expression analysis
* GSEA/GO: pathway and gene ontology analysis, gene set enrichment analysis

For detailed instruction on how to execute each step, see the Readme file within each folder.

## Contributors
* Weihan Liu
* Stephanie Konecki

## Workflow
* Steps that need to be executed in linux language(either locally or on the server): FastQC, STAR, SAMTools, featureCounts
* Steps that need to be excecuted in R: DeSeq2, GSEA/GO

