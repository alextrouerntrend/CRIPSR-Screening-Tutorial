# CRISPR Screening Pipeline 
# Bioinformatics and Statistics Core @ UF|Scripps
# Contact: aj.trouerntrend@ufl.edu

#---
  
# Install prerequisite packages.
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("MAGeCKFlute")

library(MAGeCKFlute)
library(clusterProfiler)
library(ggplot2)

#---
# Analysis and visualization of MAGeck count result

getwd()
setwd("~/bioinf_core/clients/mu/october_dataset/mageck_trimmed_noUMI/")
countsummary = read.delim(file = "mageck_trimmed_noUMI.countsummary.txt",
                          check.names = FALSE)
head(countsummary)

# Visualize the QC results
# Gini index
BarView(countsummary, x = "Label", y = "GiniIndex",
        ylab = "Gini index", main = "Evenness of sgRNA reads")

# Missed sgRNAs
countsummary$Missed = countsummary$Zerocounts
BarView(countsummary, x = "Label", y = "Missed", fill = "#394E80",
        ylab = "Missed gRNAs", main = "Missed sgRNAs")

# Read mapping
MapRatesView(countsummary)

# Analysis and visualization of mageck test results
test_results_folder <- "test_results/"
sgrna_files <- list.files(path = test_results_folder, pattern = "\\.sgrna_summary\\.txt$", full.names = TRUE)
gene_files <- list.files(path = test_results_folder, pattern = "\\.gene_summary\\.txt$", full.names = TRUE)
prefixes <- sub("\\.sgrna_summary\\.txt$", "", basename(sgrna_files))

# testing for dup rownames
duplicated <- duplicated(gdata$id)
gdata[duplicated, ]
table(duplicated)

?ResembleDepmap

# Function that uses sgrna_summary_txt to assess gene-level capture.
id_missed_genes <- function(i) {
  sgrna_fulldata = read.csv(sgrna_files[i], sep = "\t")
  all_genes <- unique(sgrna_fulldata$Gene)
  captured_genes <- unique(sgrna_fulldata$Gene[sgrna_fulldata$treatment_count > 0])
  missed_genes <- setdiff(all_genes, captured_genes)
  number_missed <- length(missed_genes)
  number_missed_vector <- c(number_missed_vector, number_missed)
  return(missed_genes)
}

nmv <- c(number_missed)
nmv <- c(nmv, number_missed)

# loop through libraries and make figures.
for (i in seq_along(prefixes)) {
  comparison <- prefixes[i]
  print(paste("Processing: ", comparison))
  # gene-level analysis
  gdata = ReadRRA(gene_files[i])
  depmap_similarity = ResembleDepmap(gdata, symbol = "id", score = "Score")
  sdata = ReadRRA(sgrna_files[i])
  gdata = OmitCommonEssential(gdata, symbol = "id")
  sdata = OmitCommonEssential(sdata, symbol = "Gene")
  # make volcano plot
  gdata$LogFDR = -log10(gdata$FDR)
  p1 = ScatterView(gdata, x = "Score", y = "LogFDR", label = "id", 
                   model = "volcano", top = 5)
  print(p1)
  # make rank plot
  gdata$Rank = rank(gdata$Score)
  p1 = ScatterView(gdata, x = "Rank", y = "Score", label = "id", 
                   top = 5, auto_cut_y = TRUE, ylab = "Log2FC", 
                   groups = c("top", "bottom"))
  print(p1)
}
id_missed_genes(2)
missed_genes_list <- c()
number_missed_vector <- c()
for (i in seq_along(prefixes)) {
  # identify missed genes and make a list
  missed_genes_list <- append(missed_genes_list, list(id_missed_genes(i)))
}

#name elements of list of lists using the prfix list
names(missed_genes_list) <- prefixes
# Convert the list of lists to a data frame
missed_genes_df <- do.call(rbind, lapply(names(missed_genes_list), function(name) {
  data.frame(Name = name, List = I(list(missed_genes_list[[name]])))
}))

# add col to the dataframe used to graph hit vs miss at gene level.
missed_genes_df$number_missed <- number_missed_vector
BarView(missed_genes_df, x = "Name", y = "number_missed", fill = "#394E80",
        ylab = "Missed genes", main = "Missed genes")

