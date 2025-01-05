
firsts <- as.data.frame(table(counts$firstyear[counts$firstyear > 0]))
names(firsts) <- c("year", "species")
firsts$year <- as.integer(as.character(firsts$year))
print(lm(log(species) ~ year, data=firsts))

years <- as.data.frame(table(pmid_df$year))
names(years) <- c("year", "pubs")
years$year <- as.integer(as.character(years$year))
print(lm(log(pubs) ~ year, data=years))

data <- dplyr::full_join(firsts, years, by="year")
data$species[is.na(data$species)] <- 0
data$pubs[is.na(data$pubs)] <- 0
data <- data[order(data$year), ]
data$new_species <- data$species
data$species <- cumsum(data$species)
data$ratio <- data$pubs / data$species

data <- data[data$year >= 1970 & data$year <= 2022, ]
plot(data$year, data$pubs / data$species)
