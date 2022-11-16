## Microbiology capstone 2022


This repo contains the code for analyzing the Nanopore data for the 2022 microbiology capstone class at UW. Most of this is not particularly optimized code that was done on the fly.

slurm scripts are to be deployed on Teton. Change my email and the Teton account if you use them.

R scripts can be run anywhere, I've been running them locally.



- soil_basecall.slurm basecalls the raw fast5 files

-  move\_empty_dirs.txt has a few lines I ran in the terminal to move the empty directories with no data in them into a separate location

- emu.slurm runs Emu on the fastq files for each sample to get the abundances

- Directory capstone_ONT contains the abundances and counts of taxa in each sample as output by Emu.

- make\_OTU_table.R  combines all of the data across samples to make a single OTU table and spit it out as a .csv file. It also spits out a file that maps numeric taxon IDs to taxonomic names.

- OTU_diversity.R will take the output OTU table from the previous R script and start to actually analyze it. 

