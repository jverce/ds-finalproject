#!/usr/bin/env Rscript

library(optparse)
library(quanteda)

IN_FILENAMES <- c(
  "en_US.blogs.txt",
  "en_US.news.txt",
  "en_US.twitter.txt"
)
OUT_FILENAME <- "ngrams.dat"
NUM_NGRAMS <- 3
SAMPLE_RATE <- .05

option_list <- list(
  make_option(
    c("-d", "--dir"), type = "character", default = ".",
    help = "Input dir location", metavar = "character"),
  make_option(
    c("-o", "--out"), type = "character", default = "ngrams.dat",
    help = "Output file name", metavar = "character")
)
opt_parser <- OptionParser(option_list = option_list)
opts <- parse_args(opt_parser)

dir <- opts$dir
out <- opts$out

corpus <- c()
for (filename in IN_FILENAMES) {
  filePath <- sprintf("%s/%s", dir, filename)
  f <- file(filePath)
  print(sprintf("Reading input file %s", filePath))
  txt <- readLines(f, skipNul = TRUE)
  close(f)

  lineCount <- length(txt)
  sampleCount <- floor(lineCount * SAMPLE_RATE)
  txt <- sample(txt, size = sampleCount)

  print(sprintf("Cleanining up..."))
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
  print(sprintf("Generating %d-gram", i))
  ngrams <- c(
    dfm(
      corpus, ngrams = i, concatenator = " ",
      remove_numbers = TRUE, remove_punct = TRUE, remove_url = TRUE,  remove_symbols = TRUE
    ),
    ngrams
  )
}

print(sprintf("Storing N-grams as data file"))
result <- save(ngrams, file = out)
