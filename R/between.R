#' Extract text between patterns
#'
#' @param txt A character vector
#' @param before,after Patterns which surround the text to extract
#' @param include Should element containing `before` and `after` be included?
#'
#' @return The extracted text
#' @export
#'
#' @importFrom stringr str_which
#' @examples
#' extract_between(month.abb, "Fe", "Oc")
#' extract_between(month.abb, "Fe", "Oc", include = FALSE)
extract_between <- function(txt, before = NULL, after = NULL, include = TRUE) {
  i <- 1
  if (!is.null(before)) {
    i <- min(str_which(txt, before))
    if (!include) {
      i <- i + 1
    }
  }

  j <- length(txt)
  if (!is.null(after)) {
    j <- max(str_which(txt, after))
    if (!include) {
      j <- j - 1
    }
  }

  stopifnot(i <= j)
  return(txt[seq(i, j)])
}
