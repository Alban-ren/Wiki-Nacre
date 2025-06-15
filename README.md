# Wiki noble pen shell
------------------------
This repository has been created as part of a research project investigating genomic and transcriptomic features related to the resistance of the Mediterranean fan mussel (*Pinna nobilis*) and its related species (*Pinna rudis*) to the protozoan parasite *Haplosporidium pinnae*. The study was conducted under the supervision of Dr. Stéphane Coupé at the Mediterranean Institute of Oceanography (MIO), EMBIO team.

The main goal of this work was to contribute to the bioinformatic analyses required for genome assembly, annotation, and functional gene characterization of *Pinna spp*., with a particular focus on immune-related genes and associated bacterial communities.

*H. pinnae* is a parasitic protozoan that infects the Mediterranean endemic bivalve *Pinna nobilis* (and its closely related species *Pinna rudis*), commonly known as the noble pen shell (Linnaeus, 1758). This infection is responsible for mass mortality events (MMEs) in noble pen shell populations and facilitates the entry of other pathogenic organisms, contributing to a multifactorial disease (Coupé *et al*., 2022).
Although some cases of resistance in *P. nobilis* and tolerance in *P. rudis* and *P. nobilis* × *P. rudis* hybrids have been reported, the latter two appear to be naturally resistant to the parasite (Coupé *et al.*, 2022).

It is important to generate high-quality transcriptome assemblies to provide reference sequences for the identification and characterization of immune-related genes involved in resistance to *Haplosporidium pinnae* in *Pinna nobilis* and related taxa.
In this study, de novo transcriptome assemblies were produced and used to support genome annotation and to extract Toll-like receptor (TLR) sequences. The identified TLR repertoires reveal substantial diversification of these rapidly evolving immune genes, which may reflect species-specific adaptation to marine pathogenic pressures (Coupé *et al.*, 2022; Gerdol *et al*., 2017).


# In this wiki, you will find:

* The different pipelines used for transcriptome assembly and completeness assessment of Pinna nobilis and Pinna rudis, providing references for genome annotation (see the [README_GENOMIC](genomics/README_GENOMIC.md) section),

* Explanations of the software and computational tools employed for genome assembly, contamination filtering, and gene annotation (see the [genomic](genomics/) section),

* The scripts used for the identification, extraction, and structural classification of Toll-like receptors (TLRs) from annotated genome data (see the [README_TLR](TLRs/README_TLR.md) section).

* The pipelines developed for the analysis of bacterial communities from RNA-seq raw reads, including taxonomic profiling and beta diversity analyses [bacteria](Bacteria/).
