## Kraken2
-----------
Kraken 2 is an ultra-fast software tool designed for taxonomic classification of DNA or RNA sequences derived from metagenomic data. It enables the identification and labeling of organisms present in a biological sample, down to the species level (Wood & Salzberg, 2014).
Kraken 2 is an improved version of the original Kraken, which relied on a memory-intensive algorithm with a fixed k-mer length (Wood et al., 2019).
A k-mer is defined as a contiguous sequence of amino acids or nucleotides of fixed length k (Moeckel et al., 2023). In practice, Kraken 2 splits input sequences into k-mers, compares them to a pre-built database, and assigns each read to a specific taxon using a high-speed lowest common ancestor (LCA) algorithm.

In our study, Kraken 2 was used to identify bacterial taxa present in the transcriptome of Pinna nobilis and Pinna rudis, with their relative abundance expressed as a percentage for each taxon. However, Kraken 2 is a classifier, and its estimates of taxonomic abundance are only approximate. 
-----------------------------------------------------------------------------------------------------------------------------------
To achieve more accurate quantification of bacterial taxa from a sample, the complementary software Bracken is required.
Bracken allows more precise estimation of alpha and beta diversity, even at the species level (Lu et al., 2022). That said, Bracken is typically used in contexts where target species are directly amplified, such as through PCR-based techniques.
In our case, the sequences analyzed originate from host transcriptomes (Pinna spp.), and not from bacterial DNA specifically extracted or enriched. Therefore, Bracken results may be biased, and the resulting abundance data should be interpreted as indicative rather than quantitative.
