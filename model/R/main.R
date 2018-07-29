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

#' Next word predictor
#'
#' This function generates `n` word suggestions (3 by
#' default) using a list of `quanteda` N-grams as observed data, and
#' a phrase for which you want the prediction to be based of.
#'
#' It implements a simplified version of the [Katz's backoff model]
#' (https://en.wikipedia.org/wiki/Katz%27s_back-off_model).
#'
#' @param phrase A character vector representing the preceeding words for the prediction
#' @param ngrams A vector of `quanteda` N-grams, in ascending order (e.g. 1-gram,
#' 2-gram, etc.)
#' @param n The amount of predicted words.
#' @return A vector of predicted words, ordered by descending likelihood.
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
