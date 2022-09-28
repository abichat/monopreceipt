#' Discard blanks
#'
#' @param txt A character vector.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' discard_blanks(c("hello", "", "world", "", "!", ""))
discard_blanks <- function(txt) {
  txt[txt != ""]
}


#' Convert to numeric and keep 4 digits.
#'
#' @param x A numeric-like vector.
#'
#' @return A numeric vector.
#' @export
#'
#' @examples
#' num4(c("1", "3.141593"))
num4 <- function(x) {
  x %>%
    as.numeric() %>%
    round(4)
}
