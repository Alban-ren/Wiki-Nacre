# Wiki noble pen shell
------------------------
This wiki has been created as part of a research project investigating the impact of the protozoan parasite Haplosporidium pinnae on the transcriptome of noble pen shell populations (Pinna nobilis and Pinna rudis). The study is conducted under the supervision of Stéphane Coupé.

The objectives are, firstly, to identify transcriptomic mutations in Pinna nobilis and Pinna rudis in response to infection by the protozoan parasite Haplosporidium pinnae, and secondly, to compare the bacterial taxonomic groups between sensitive and resistant individuals of these two noble pen shell species.

Haplosporidium pinnae is a parasitic protozoan that infects the Mediterranean endemic bivalve Pinna nobilis (and its closely related species Pinna rudis), commonly known as the noble pen shell (Linnaeus, 1758). This infection is responsible for mass mortality events (MMEs) in noble pen shell populations and facilitates the entry of other pathogenic organisms, contributing to a multifactorial disease (Coupé et al., 2022).
Although some cases of resistance in P. nobilis and tolerance in P. rudis and P. nobilis × P. rudis hybrids have been reported, the latter two appear to be naturally resistant to the parasite (Coupé et al., 2022).

In order to better understand the mechanisms underlying tolerance and resistance, it is essential to investigate genomic variations both between species and among individuals exhibiting differential susceptibility.

It is therefore essential to obtain a complete genome from a resistant Pinna nobilis individual, which can serve as a reference for comparison with genomes from individuals infected by the parasite Haplosporidium pinnae.
The reference genome is assembled from transcriptomes of P. nobilis and P. rudis, composed of highly accurate short reads obtained from the NCBI SRA database (see the [Selected transcriptomes](./Selected_transcriptomes.md#selected-transcriptomes) section). These transcriptomes are presumed to be free from H. pinnae contamination.

To ensure this, the raw data are first “cleaned” using [Kraken2](./Kraken_2.md#Kraken2) and SeqKit, which detect, identify, and remove potential bacterial contaminations from a database containing most of the known marine bacteria(see the [Experiment Script](./Experiment_01.md#experiment-script) . The quality of the transcriptomic data is then assessed using [FastQC](./FastQC.md#FastQC). Based on these quality reports, Trimmomatic, an open-source software, is used to trim low-quality bases from the beginning and/or end of the reads in order to correct alignment errors. A second FastQC analysis is performed to confirm the improvement in read quality.

High-quality reads are then assembled using Trinity, a de novo assembler that reconstructs transcriptomes from fragmented RNA-Seq reads without the need for a reference genome. The completeness of the assembled transcriptome is assessed using BUSCO, which evaluates whether the assembly is complete, fragmented, or incomplete by searching for conserved, single-copy orthologous genes across a specific taxonomic group.

If the assembly quality is deemed satisfactory, it is processed through ORF Finder (Open Reading Frame Finder) to identify open reading frames (ORFs) within the assembled sequences, allowing the prediction of potential coding regions from randomly fragmented genomic sequences.
