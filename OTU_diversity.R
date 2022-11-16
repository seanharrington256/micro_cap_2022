# R script for analyzing the diversity of microbes in the OTU table for the micro capstone class

library(ecodist)
library(vegan)

# set the working directory
############################################################################################################################################################
## YOUR WORKING DIRECTORY WILL BE DIFFERENT FROM MINE!!!!! - this should be the path to where the rel-abundance.tsv files are
############################################################################################################################################################
setwd("~/UWyo/Bentley_Erin_capstone_class/micro_cap_2022/capstone_ONT")

# read in the data that we wrote out previously
taxon_info <- read.csv("taxon_info.csv", row.names = 1)
otu_table <- read.csv("soil_otu_table.csv", row.names = 1)



# NMDS/PCOA
dists <- ecodist::bcdist(otu_table[,4:ncol(otu_table)]) # get distances among samples
pcoa <- cmdscale(d = dists, k = 4) # run a PCoA

# assign colors for sites:
colors <- otu_table$site
colors <- gsub("site_1", "blue", colors)
colors <- gsub("site_2", "red", colors)
colors <- gsub("site_3", "yellow", colors)

# pdf(width = 7, height = 7, file = "pcoa_by_taxa_loc.pdf")
plot(type = "n", pcoa[,1], pcoa[,2],
     ylab = "PCoA #2",
     frame.plot = F,
     ylim = c(-.4,0.4),
     xlim = c(-.4,0.4),
     xlab = "PCoA #1",
     yaxt = "n",
     xaxt = "n",
     las = 2)
axis(side = 1, at = seq(-0.4,0.4,0.2), lab = seq(-0.4,0.4,0.2))
axis(side = 2, at = seq(-0.4,0.4,0.2), lab = seq(-0.4,0.4,0.2), las = 2)

points(pcoa[,1], pcoa[,2],
       pch = 21,
       cex = 1,   #1.8 in pdf, probably
       xpd = NA,
       bg = colors)
# dev.off()

# color it by pre/post
colors_prepost <- otu_table$prepost
colors_prepost <- gsub("pre", "blue", colors_prepost)
colors_prepost <- gsub("post", "red", colors_prepost)

plot(type = "n", pcoa[,1], pcoa[,2],
     ylab = "PCoA #2",
     frame.plot = F,
     ylim = c(-.4,0.4),
     xlim = c(-.4,0.4),
     xlab = "PCoA #1",
     yaxt = "n",
     xaxt = "n",
     las = 2)
axis(side = 1, at = seq(-0.4,0.4,0.2), lab = seq(-0.4,0.4,0.2))
axis(side = 2, at = seq(-0.4,0.4,0.2), lab = seq(-0.4,0.4,0.2), las = 2)

points(pcoa[,1], pcoa[,2],
       pch = 21,
       cex = 1,   #1.8 in pdf, probably
       xpd = NA,
       bg = colors_prepost)


# Permanova - NOT DONE
# perm_out <- adonis2(dune ~ Management*A1, data = otu_table, permutations = 999, method="bray")


# alpha diversity of site & time
alpha_barcodes <- vegan::diversity(otu_table[,4:ncol(otu_table)], groups = as.factor(otu_table$barcode))
alpha_sites <- vegan::diversity(otu_table[,4:ncol(otu_table)], groups = as.factor(otu_table$site))
alpha_prepost <- vegan::diversity(otu_table[,4:ncol(otu_table)], groups = as.factor(otu_table$prepost))




