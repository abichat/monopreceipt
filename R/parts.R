#' Extract specific fields
#'
#' @param raw A raw receipt.
#'
#' @return A vector or a tibble containing the desired information.
#' @export
#'
#' @importFrom stringr str_squish str_to_title
get_address <- function(raw) {
  raw %>%
    "["(2:3) %>%
    str_squish() %>%
    str_to_title()
}

#' @rdname get_address
#' @export
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

#' @rdname get_address
#' @export
#' @importFrom stringr str_remove_all str_subset
get_client <- function(raw) {
  raw %>%
    str_subset("Bonjour") %>%
    str_remove_all(" {3,}Bonjour ")
}

#' @rdname get_address
#' @export
#' @importFrom stringr str_extract
get_total <- function(raw) {
  raw %>%
    extract_between(before = "TOTAL HORS$", after = "^ * AVANTAGES",
                    include = FALSE) %>%
    str_extract("[-\\d\\.]+") %>%
    num4()
}

#' @rdname get_address
#' @export
#' @importFrom stringr str_detect str_extract
get_discount <- function(raw) {

  if(!any(str_detect(raw, "TOTAL DES REMISES"))) {
    return(0)
  }

  raw %>%
    extract_between(before = "TOTAL DES REMISES", after = NULL) %>%
    "["(1) %>%
    str_extract("[-\\d\\.]+") %>%
    num4()
}

#' @rdname get_address
#' @export
#' @importFrom stringr str_extract str_replace_all
get_topay <- function(raw) {
  raw %>%
    extract_between(before = "RESTE A PAYER", after = NULL) %>%
    "["(1) %>%
    str_extract("-?[\\d\\.,]+") %>%
    str_replace_all(",", ".") %>%
    num4()
}

#' @rdname get_address
#' @export
#' @importFrom dplyr mutate
#' @importFrom rlang .data
#' @importFrom stringr str_detect str_remove_all
#' @importFrom tibble as_tibble
get_discounts <- function(raw) {

  if(!any(str_detect(raw, "TOTAL DES REMISES"))) {
    return(NULL)
  }
  raw %>%
    extract_between(before = "MES REMISES",
                    after = "^ *TOTAL DES REMISES",
                    include = FALSE) %>%
    extract_between(before = "---{3,}",
                    after = "---{3,}",
                    include = FALSE) %>%
    discard_blanks() %>%
    str_remove_all("^ *") %>%
    str_split(" {3,}") %>%
    unlist() %>%
    matrix(ncol = 2, byrow = TRUE,
           dimnames = list(NULL, c("discount_name", "total"))) %>%
    as_tibble() %>%
    mutate(total = as.numeric(str_remove_all(.data$total, "[^\\d-.]")))
}

#' @rdname get_address
#' @export
#' @importFrom purrr map_dfr
get_purchases <- function(raw) {
  raw %>%
    extract_purchases() %>%
    products_contents() %>%
    map_dfr(product_info)
}
