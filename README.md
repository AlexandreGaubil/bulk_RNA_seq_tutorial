# bulk RNA sequencing work flow

Work flow for bulk RNA sequencing

## Table of content
* Overview
* Contributors
* Workflow
* Study Design

## Overview
This this the general description of the RNA seq workflow, using experiment SNK015 as an example. The repository is organized in two folders, code and data. In code folder, there are scripts for the following steps of workflow.For detailed instruction on how to execute each step, see the Readme file within code folder.
* FastQC: initial quality control
* STAR : read alignment to the genome
* SAMTools: sorting, filtering and indexing bam/sam files after alignment
* featureCounts: count number of transcripts and assign them to features(genes)
* DeSeq2: differential expression analysis
* GSEA/GO: pathway and gene ontology analysis, gene set enrichment analysis

Data folder contains intermediate summary data and for large data on server, their paths are recorded in the readme file of data folder.


## Contributors
* Weihan Liu
* Stephanie Konecki

## Workflow
* Steps that need to be executed in linux language(either locally or on the server): FastQC, STAR, SAMTools, featureCounts
* Steps that need to be excecuted in R: DeSeq2, GSEA/GO

## Study Design
See the attched powerpoint slide in this folder

