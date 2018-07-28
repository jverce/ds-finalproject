library(quanteda)

IN_FILENAMES <- c(
  "en_US.blogs.txt",
  "en_US.news.txt",
  "en_US.twitter.txt"
)
OUT_FILENAME <- "ngrams.dat"
NUM_NGRAMS <- 3
SAMPLE_RATE <- .05


setwd("/Users/jay/dev/ds/capstone/final/en_US/")
corpus <- c()
for (filename in IN_FILENAMES) {
  f <- file(filename)
  txt <- readLines(f, skipNul = TRUE)
  close(f)

  lineCount <- length(txt)
  sampleCount <- floor(lineCount * SAMPLE_RATE)
  txt <- sample(txt, size = sampleCount)

  txt <- tolower(txt)
  sentences <- tokens(
    txt, what = "sentence",
    remove_numbers = TRUE, remove_punct = TRUE, remove_url = TRUE,  remove_symbols = TRUE
  )
  sentences <- unname(unlist(sentences))
  corpus <- c(corpus, sentences)
}

ngrams <- c()
for (i in 1:NUM_NGRAMS) {
  ngrams <- c(
    dfm(
      corpus, ngrams = i, concatenator = " ",
      remove_numbers = TRUE, remove_punct = TRUE, remove_url = TRUE,  remove_symbols = TRUE
    ),
    ngrams
  )
}

save(ngrams, file = "ngrams.dat")
