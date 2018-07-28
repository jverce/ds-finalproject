library(quanteda)

NUM_SUGGESTIONS <- 3


getRegex <- function(phrase, n) {
  # An all-match regex for empty phrases
  regex <- "^.*"

  if (n > 0) {
    phrase <- char_tolower(phrase)
    phrase <- tokens(
      phrase, what = "fasterword",
      remove_numbers = TRUE, remove_punct = TRUE, remove_url = TRUE, remove_symbols = TRUE)

    last <- tail(phrase[[1]], n)
    last <- paste(last, collapse = " ")
    regex <- sprintf("^%s .*", last)
  }

  regex
}

topMatches <- function(pattern, ngram, n = NUM_SUGGESTIONS) {
  filtered <- dfm_select(
    ngram, pattern = pattern, selection = "keep", valuetype = "regex")
  top <- topfeatures(filtered, n)
  names(top)
}

suggestNextWords <- function(phrase, ngrams, n = NUM_SUGGESTIONS) {
  suggestions <- c()
  remainingSuggestions <- n

  for (ngram in ngrams) {
    pattern <- getRegex(phrase, n = ngram@ngrams - 1)
    matches <- topMatches(pattern, ngram, n = remainingSuggestions)
    for (match in matches) {
      match <- tokens(match, what = "word")
      match <- match$text1
      suggestions <- c(suggestions, tail(match, 1))
    }

    remainingSuggestions <- n - length(suggestions)
    if (remainingSuggestions == 0) {
      break
    }
  }

  head(suggestions, NUM_SUGGESTIONS)
}
