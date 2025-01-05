
pmid_df <- as.data.frame(readr::read_csv("pmids_dates_updated.csv", col_names=c("pmids", "year"), col_type="ci"))
pmid_df <- pmid_df[!duplicated(pmid_df$pmids), ]
rownames(pmid_df) <- pmid_df$pmids
pmid_df$cites <- 0

counts$firstyear <- 0

notfound <- c()

for (i in 1:nrow(counts)) {
#for (i in 1:10) {
  final <- paste0(counts$id[i], "_final.txt")
  if (counts$fullname_only[i]) {
    system(sprintf("cat pmids/%s | uniq > pmids/%s", counts$pmid_file[i], final))
  } else {
    system(sprintf("cat pmids/%s pmids/%s | uniq > pmids/%s", counts$pmid_file[i], counts$pmid_abbr_file[i], final))
  }
  pmids <- readr::read_csv(paste0("pmids/", final), col_names="pmid", col_types = "c")
  nf <- pmids$pmid[!(pmids$pmid %in% rownames(pmid_df))]
  if (length(nf) > 0) {
    notfound <- c(notfound, nf)
  }
  pmids$year <- pmid_df[pmids$pmid, "year"]
  pmid_df[pmids$pmid, "cites"] <- pmid_df[pmids$pmid, "cites"] + 1
  if (nrow(pmids) > 0) {
    counts$firstyear[i] <- min(pmids$year)
  } else {
    counts$firstyear[i] <- NA
  }
  readr::write_csv(pmids, file=paste0("pmids/", counts$id[i], ".csv"))
  print(c(i, counts$firstyear[i], length(notfound)))
}

total_pmids <- sum(pmid_df$cites > 0)
total_cites <- sum(counts$total)

counts$freq <- counts$total / total_cites
counts$percent <- counts$freq * 100
counts <- counts[order(counts$freq, decreasing=TRUE), ]
counts$cum_percent <- cumsum(counts$percent)

readr::write_csv(counts, file="final_counts.csv")
readr::write_csv(pmid_df, file="pmids_counts.csv")
