#' Exctract adress field
#'
#' @param raw A raw receipt.
#'
#' @return A length-two vector.
#' @export
#'
#' @importFrom stringr str_squish str_to_title
get_adress <- function(raw) {
  raw %>%
    "["(2:3) %>%
    str_squish() %>%
    str_to_title()
}
