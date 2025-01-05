
library(magrittr)

# load all species names
tax <- readr::read_tsv("bac120_taxonomy_r202.tsv", col_names=c("genome", "taxonomy"))
tax$species <- stringr::str_match(tax$taxonomy, ";s__(.*)")[ ,2]
species <- unique(tax$species) %>% stringr::str_remove_all("_[A-Z]+")
species <- unique(species)

binomial_abbreviation <- function (name) {
  stringr::str_replace(name, "^([A-Z])\\w* (.*)", "\\1. \\2")
}

species <- tibble::tibble(
  id = sprintf("%06i", 1:length(species)),
  fullname = species,
  abbreviation = binomial_abbreviation(species)
)
species$filename_full <- sprintf("%s.txt", species$id)
species$fillname_abbreviated <- sprintf("%s_abbreviated.txt", species$id)

readr::write_csv(species, file="species.csv", col_names=FALSE)
