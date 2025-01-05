
pmids <- readr::read_csv("pmids_dates_updated.csv", col_names = c("pmid", "year"))


get_year <- function(pmid) {
  #query <- "39619292[uid]"
  entrez_id <- easyPubMed::get_pubmed_ids(paste0(pmid, "[uid]"))
  result <- easyPubMed::fetch_pubmed_data(entrez_id) %>% easyPubMed::custom_grep("Year")
  result[[1]]
}

total_nas <- sum(is.na(pmids$year))
found <- 0
for (i in 1:nrow(pmids)) {
  if (is.na(pmids$year[i])) {
    pmids$year[i] <- as.integer(get_year(pmids$pmid[i]))
    found <- found + 1
    print(sprintf("Found %i/%i [%3.1f%%]", found, total_nas, found/total_nas*100))
  }
}

