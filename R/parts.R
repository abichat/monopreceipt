#' Extract specific fields
#'
#' @param raw A raw receipt.
#'
#' @return A vector containing the desired information.
#' @export
#'
#' @importFrom stringr str_squish str_to_title
get_adress <- function(raw) {
  raw %>%
    "["(2:3) %>%
    str_squish() %>%
    str_to_title()
}

#' @rdname get_adress
#' @importFrom stringr str_remove_all
get_date <- function(raw) {
  raw %>%
    extract_between(before = "Total TVA", after = "SERVICE CLIENTS MONOPRIX",
                    include = FALSE) %>%
    str_remove_all("-{5,}") %>%
    paste(collapse = "") %>%
    str_remove_all("^ *") %>%
    str_split(pattern = " ") %>%
    unlist() %>%
    "["(1:2)
}

#' @rdname get_adress
#' @importFrom stringr str_extract
get_total <- function(raw) {
  raw %>%
    extract_between(before = "TOTAL HORS$", after = "^ * AVANTAGES",
                    include = FALSE) %>%
    str_extract("[-\\d\\.]+") %>%
    as.numeric()
}

#' @rdname get_adress
#' @importFrom stringr str_extract
get_discount <- function(raw) {
  raw %>%
    extract_between(before = "TOTAL DES REMISES", after = NULL) %>%
    "["(1) %>%
    str_extract("[-\\d\\.]+") %>%
    as.numeric()
}

#' @rdname get_adress
#' @importFrom stringr str_extract
get_topay <- function(raw) {
  raw %>%
    extract_between(before = "RESTE A PAYER", after = NULL) %>%
    "["(1) %>%
    str_extract("[-\\d\\.]+") %>%
    as.numeric()
}
