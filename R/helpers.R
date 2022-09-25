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
