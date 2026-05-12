# Basic_Nextflow_Pipeline
Simple nextflow pipeline integrating parallel and sequential tasks created for the GT BIOL 7210 course

# workflow_assignment
Nextflow Workflow Assignment for 7210
---

# Project Description

The purpose of this project is to get an introduction to nextflow and its abilities for parallelizing tasks (as well as running sequentially with one output feeding into the next input). In this particular workflow, I have 3 steps (originally I had a more ambitious idea but that invovled creating my own modules but ultimately, I did not have enough time to troubleshoot and had to pivot. I still plan to work on this other idea in the future, fingers crossed). The three steps are as follows: 1. sequence trimming and quality filtering with fastp, 2. metagneome assembly with the --meta option for SPAdes, 3. competative mapping of a mag against a metagenome to determine percent reads mapped. 


---

# Workflow

Raw illumina metagenome reads (fastq.gz) ---> Fastp (trimming) ---> trimmed fastq files (fastq.gz) ---> SPAdes (assembly) ---> contigs.fasta file

Raw illumina metagenome reads (fastq.gz) ---> Fastp (trimming) ---> trimmed fastq files (fastq.gz) ---> mag.fasta ---> bowtie2-build (build index with mag) --->> bowtie2 (competative mapping of mag and metagenome)


<img width="653" height="216" alt="workflow_assignment_image_7210" src="https://github.gatech.edu/user-attachments/assets/a892dcee-b41c-47e2-b51c-41cea68be310" />


---

# Environment & Version Information

| Software | Version | Notes |
|----------|---------|-------|
| x86_64 GNU/Linux, Ubuntu 22.04.5 LTS, WSL2 | 22.04.5  | OS and architecture |
| conda | 26.1.0 | Environment and package manager |
| nextflow | 25.10.4 | Nexflow workflow management tool |


# Software utilized by Nextflow 

| Software | Notes |
|----------|-------|
| Fastp | Read trimming tool |
| SPAdes | Contig assembly tool |
| Bowtie2 | Mapping of reads to refernce (in this case, mag to metagenome) |

---------------------

**Setup:** A conda environment is needed to run nextflow.
``` bash
conda create -n nextflow -c conda-forge -c bioconda nextflow nf-core -y
conda activate nextflow
```

# Script run for testing the workflow

``` bash
nextflow run main.nf -profile test,conda
```

---------------------

# Description of test data 
The test data in this nextflow repository consists of one MAG (metaegenome assembled genome) and a subsampling of one metageome reads, both R1 and R2 (for ease of running). The mag is in a fasta format while the metagenome read files are in fastq.gz format. This data came from the paper cited below with the metagenome coming from Lake Lanier and the mag being a bacterial genome whose abundance was highest in this metagenome. 
Citation: Rodriguez‐R, L. M., Tsementzi, D., Luo, C., & Konstantinidis, K. T. (2020). Iterative subtractive binning of freshwater chronoseries metagenomes identifies over 400 novel species and their ecologic preferences. Environmental microbiology, 22(8), 3394-3412.

**Input:** One MAG.fasta file and an R1 and R2 metagenome read file(s).

``` bash
test_mag.fasta
test_metagenome_R1.fastq.gz
test_metagenome_R2.fastq.gz
```


**Expected Outputs:** ``` test_results ```


| File | Description |
|----------|---------|
| pipeline_dag.html | shows the workflow visually |
| pipeline_report.html | gives metrics for the pipeline processes |




**Expected Outputs:** ``` results ```


| File | Description |
|----------|---------|
| fastp/metagenome_<R1_or_R2>.fastp.fastq.gz | trimmed metagenome reads, both R1 and R2 |
| spades/metagenome.contigs.fa.gz | assembled contigs for the metagenome |
| bowtie2/align/metagenome.bam | aligned reads |
| bowtie2/align/metagenome.bowtie2.log | bowtie log file - gives percent reads mapped |





# Tool References
- **Fastp**:Chen, S., Zhou, Y., Chen, Y., & Gu, J. (2018). fastp: an ultra-fast all-in-one FASTQ preprocessor. Bioinformatics, 34(17), i884-i890.
- **SPAdes**:Prjibelski, A., Antipov, D., Meleshko, D., Lapidus, A., & Korobeynikov, A. (2020). Using SPAdes de novo assembler. Current protocols in bioinformatics, 70(1), e102.
- **Bowtie2**:Langmead, B., & Salzberg, S. L. (2012). Fast gapped-read alignment with Bowtie 2. Nature methods, 9(4), 357-359.
