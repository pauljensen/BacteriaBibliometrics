
col_names <- c("id", "name", "abbr_name", "pmid_file", "pmid_abbr_file", 
               "count", "count_abbr")

counts <- readr::read_csv("species_counts.csv", col_names=col_names)
counts$ratio <- (counts$count_abbr + 1) / (counts$count + 1)

# sort by publications with full name
counts <- counts[order(counts$count, decreasing = TRUE), ]
counts$duplicated <- duplicated(counts$abbr_name)

fullname_only <- c(
  "Actinobacillus minor",
  "Aminobacterium mobile",
  "Spirulina major",
  "Aeromonas media",
  "Prochlorococcus pastoris", # likely yeast Pichia
  "Entotheonella factor",
  "Streptococcus minor",
  "Acholeplasma modicum ",
  "Bifidobacterium minimum",
  "Ignatzschineria larvae",
  "Chachezhania antarctica",
  "Streptomyces niger",
  "Senegalimassilia faecalis",
  "Microbacterium hominis",
  "Erysipelothrix larvae"
)
counts$fullname_only <- counts$duplicated | (counts$name %in% fullname_only)

counts$total <- ifelse(counts$fullname_only, counts$count, counts$count_abbr)
counts <- counts[order(counts$ratio, decreasing = TRUE), ]



