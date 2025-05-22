# Wiki noble pen shell
------------------------
This wiki has been created as part of a research project investigating the impact of the protozoan parasite Haplosporidium pinnae on the transcriptome of noble pen shell populations (Pinna nobilis and Pinna rudis). The study is conducted under the supervision of Stéphane Coupé.

The main objective of this study is to identify transcriptomic mutations in P. nobilis and P. rudis in response to infection by the protozoan parasite Haplosporidium pinnae, through transcriptomic comparison between healthy and infected individuals.

Haplosporidium pinnae is a parasitic protozoan that infects the Mediterranean endemic bivalve Pinna nobilis (and its closely related species Pinna rudis), commonly known as the noble pen shell (Linnaeus, 1758). This infection is responsible for mass mortality events (MMEs) in noble pen shell populations and facilitates the entry of other pathogenic organisms, contributing to a multifactorial disease (Coupé et al., 2022).
Although some cases of resistance in P. nobilis and tolerance in P. rudis and P. nobilis × P. rudis hybrids have been reported, the latter two appear to be naturally resistant to the parasite (Coupé et al., 2022).

In order to better understand the mechanisms underlying tolerance and resistance, it is important to investigate genomic variations both between species and among individuals exhibiting differential susceptibility.

It is therefore essential to obtain a complete genome from a healthy Pinna nobilis individual, which can serve as a reference for comparison with genomes from individuals infected by the parasite Haplosporidium pinnae.
The reference genome is assembled from transcriptomes of P. nobilis and P. rudis, composed of highly accurate short reads obtained from the NCBI SRA database (see the [Selected transcriptomes](./Selected_transcriptomes.md#selected-transcriptomes) section). These transcriptomes are presumed to be free from H. pinnae contamination.

To ensure this, the raw data are first “cleaned” using [Kraken2](./Kraken_2.md#Kraken2) and SeqKit, which detect, identify, and remove potential bacterial contaminations from a database containing most of the known marine bacteria (see the [experiment](./Experiment_01.md#experiment-script) section for more details on the script) . The quality of the transcriptomic data is then assessed using [FastQC](./FastQC.md#FastQC). Based on these quality reports, Trimmomatic, an open-source software, is used to trim low-quality bases from the beginning and/or end of the reads in order to correct alignment errors. A second FastQC analysis is performed to confirm the improvement in read quality.

High-quality reads are then assembled using Trinity, a de novo assembler that reconstructs transcriptomes from fragmented RNA-Seq reads without the need for a reference genome. The completeness of the assembled transcriptome is assessed using BUSCO, which evaluates whether the assembly is complete, fragmented, or incomplete by searching for conserved, single-copy orthologous genes across a specific taxonomic group.

If the assembly quality is deemed satisfactory, it is processed through ORF Finder (Open Reading Frame Finder) to identify open reading frames (ORFs) within the assembled sequences, allowing the prediction of potential coding regions from randomly fragmented genomic sequences.
The contaminated transcriptomes used in this study originate from various Mediterranean locations (Greece, Italy, Spain, and France). Unlike the previously used healthy transcriptomes, these are composed of long reads. Therefore, the genome assembly pipeline differs from that used for short reads, although the objective remains the same.

The sequencing quality of the contaminated transcriptomes is first assessed using FastQC. If the quality is acceptable, bacterial sequences are removed using Kraken2, as described earlier. Similarly, data quality is re-evaluated with FastQC, and low-quality bases are trimmed from the reads using Trimmomatic.High-quality reads are assembled de novo using Flye, an assembler optimized for long-read sequencing data. To reduce redundancy caused by assembly artifacts, Purge_dups is applied to remove duplicated contigs. Remaining contigs are scaffolded using P_RNA_Scaffolder, which leverages paired-end RNA-seq alignments to connect expressed regions belonging to the same locus. Assembly quality is evaluated using BUSCO for completeness and QUAST for structural metrics such as N50 and L50, which reflect assembly contiguity and fragmentation.

Structural gene annotation is performed with BRAKER3, which integrates transcriptomic (RNA-seq) and protein homology evidence to train ab initio predictors. BRAKER3 produces GFF3 files for gene models and FASTA files for coding sequences. Predicted proteins are then aligned using DIAMOND against a reference database (UniProt) to infer putative functions via homology.


In parallel with the transcriptomic analysis of Pinna nobilis, a study of the bacterial diversity associated with the mantle tissues of these organisms was conducted to determine whether the bacterial communities differ between healthy individuals and those infected by the parasite Haplosporidium pinnae. To this end, output files generated by Kraken2 (see Kraken2 section), containing the bacterial taxa identified in the transcriptomes, were used as a basis for analysis. Each output file lists the bacterial taxa detected and the number of reads assigned to each.

In the Bash script below, a minimum threshold of 10 reads was established to reduce the likelihood of false positives due to taxonomic misassignments. This threshold is arbitrary, as there is currently no consensus regarding metagenomic identification in non-targeted transcriptomic datasets generated by Illumina sequencing.

Bacterial taxa with read counts equal to or above this threshold were selected and used to construct a presence/absence matrix. In this matrix, columns represent the different samples and rows correspond to the identified bacterial taxa. The presence of a taxon in a sample is marked with a “1” in the corresponding cell, while its absence is marked with a “0”. The full script used to generate this matrix is available in the “Bacteria” section.

The resulting binary matrix summarizes the presence or absence of bacterial taxa across samples. The objective is to compare bacterial diversity among samples in relation to biological, ecological, or geographic factors. Beta diversity analysis is particularly appropriate for this type of data, as it quantifies variation in species composition between samples or sites of interest (Legendre & De Cáceres, 2013).


