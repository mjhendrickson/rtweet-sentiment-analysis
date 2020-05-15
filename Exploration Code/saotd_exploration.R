# Load libraries
library('tidyverse')
library('rtweet')
library('saotd')
library('knitr') # for Kable

# Get Twitter Data
mh      <- get_timeline('mjhendrickson', n = 5000, include_rts = FALSE)

# Keep only text field
mh_text <- select(mh, text)

# Extract tokens & remove stops
mh_tidy <- tweet_tidy(DataFrame = mh_text)

# N-Grams
unigram <- unigram(DataFrame = mh_tidy)
bigram  <- bigram(DataFrame = mh_tidy)
trigram <- trigram(DataFrame = mh_tidy)

# Determine Commonly Associated Words for Blending - unigram
unigram %>% 
	top_n(100) %>% 
	kable()

# Determine Commonly Associated Words for Blending - Bigram
# data + science, data + privacy, cheat + sheet, rstats + packages, sentiment + analysis, github + page
bigram %>% 
	top_n(100) %>% 
	kable()

# Determine Commonly Associated Words for Blending - Trigram
# exploratory + data + analysis
trigram %>% 
	top_n(100) %>% 
	kable()

# Merge common pairs
mh_merge_1 <- merge_terms(DataFrame = mh_tidy,
												term = "data science",
												term_replacement = "datascience")

mh_merge_2 <- merge_terms(DataFrame = mh_merge_1,
												term = "data privacy",
												term_replacement = "dataprivacy")

mh_merge_3 <- merge_terms(DataFrame = mh_merge_2,
												term = "cheat sheet",
												term_replacement = "cheatsheet")

mh_merge_4 <- merge_terms(DataFrame = mh_merge_3,
												term = "rstats packages",
												term_replacement = "rstats_packages")

mh_merge_5 <- merge_terms(DataFrame = mh_merge_4,
												term = "sentiment analysis",
												term_replacement = "sentimentanalysis")

mh_merge_6 <- merge_terms(DataFrame = mh_merge_5,
												term = "github page",
												term_replacement = "githubpage")

mh_merge   <- merge_terms(DataFrame = mh_merge_6,
												term = "exploratory data analysis",
												term_replacement = "exploratorydataanalysis")

rm('mh_merge_1')
rm('mh_merge_2')
rm('mh_merge_3')
rm('mh_merge_4')
rm('mh_merge_5')
rm('mh_merge_6')

# Recompute N-Grams
unigram <- unigram(DataFrame = mh_merge)
bigram  <- bigram(DataFrame = mh_merge)
trigram <- trigram(DataFrame = mh_merge)

# Bigram Network
bigram_network(BiGramDataFrame = bigram,
							 number = 75,
							 layout = "fr",
							 set_seed = 1234)

# Sentiment Calculation
mh_scores <- tweet_scores(DataFrameTidy = mh_merge,
													HT_Topic = "text")
