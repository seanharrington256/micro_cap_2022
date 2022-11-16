# load up relevant libraries
library(tidyverse)

# set the working directory
############################################################################################################################################################
## YOUR WORKING DIRECTORY WILL BE DIFFERENT FROM MINE!!!!! - this should be the path to where the rel-abundance.tsv files are
############################################################################################################################################################
setwd("~/UWyo/Bentley_Erin_capstone_class/micro_cap_2022/capstone_ONT")

# list out all of the files that include rel-abundance
infiles <- list.files(pattern = "rel-abundance")

# read all of these in using a loop
barcodes_data <- list() # make a list to dump the data into
counts <- list() # and another, different list that will just have the counts, barcodes, and tax id
for(i in 1:length(infiles)){ # for each number from 1 to the length of the infiles object:
  barcodes_data[[i]] <- read.delim(infiles[i]) # read in each file to an element of the list
  barcode <- gsub("_all__rel-abundance.tsv", "",  infiles[i]) # get the name of the barcode, stripping the "_all__rel-abundance.tsv" off of the file names
  names(barcodes_data)[i] <- barcode # add this as the name of the current element of the list
  barcodes_data[[i]] <- cbind(rep(barcode, nrow(barcodes_data[[i]])), barcodes_data[[i]]) # make a new column of the current element of the list that is the barcode
  colnames(barcodes_data[[i]])[1] <- "barcode" # get a better column name for that new column
  counts[[i]] <- barcodes_data[[i]][,c("barcode", "tax_id", "estimated.counts")] # get just the barcodes, taxa IDs, and counts into a list
}

# make a long dataframe that is the counts of each taxon ID for each barcode
all_counts <- do.call(rbind, counts)


# make that wider - we want columns to be the taxon IDs, rows to be samples, and the values in each cell to be the counts
otu_table <- pivot_wider(all_counts, names_from = tax_id, values_from = estimated.counts)

# We can write this to a .csv file so that we don't have to remake it each time we want to analyze it
write.csv(otu_table, file = "soil_otu_table.csv")


# get out the mappings of taxon IDs to taxonomic names
taxon_info <- do.call(rbind, barcodes_data)[, c("tax_id", "species", "genus", "family", "order", "class", "phylum", "clade", "superkingdom", "subspecies", "species.subgroup", "species.group")]
# do a couple quick checks for my own sake - make sure that the number of tax_id and species matches, and that they have the same number of unique entries
# basically just checking that we don't have multiple species that map to the same tax_id or vice versa
# I'd normally exclude this from the script after running this check to reassure myself, but I'm leaving this in to see my thought and code process
length(taxon_info$tax_id)
length(taxon_info$species)
length(unique(taxon_info$tax_id))
length(unique(taxon_info$species))

# remove duplicates
taxon_info <- taxon_info[!duplicated(taxon_info$tax_id), ]# get only the rows with a unique tax_id
length(taxon_info$tax_id) # this is what we expect, cool
write.csv(taxon_info, file = "taxon_info.csv") # write it out to a file




