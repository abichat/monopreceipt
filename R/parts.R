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
