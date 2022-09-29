extract_purchases <- function(raw) {
  raw %>%
    extract_between(before = "Client",
                    after = "TOTAL HORS$", include = FALSE) %>%
    extract_between(after = "==={3,}", include = FALSE) %>%
    discard_blanks()
}


products_start_line <- function(txt) {
  str_which(txt, "^ {2,3}[\\d\\.]+ ")
}

#' @importFrom purrr map2
following_lines <- function(indices, last) {
  map2(indices, c(indices[-1] - 1, last), seq)
}

#' @importFrom purrr map
products_contents <- function(txt) {
  indices <-
    txt %>%
    products_start_line() %>%
    following_lines(length(txt))

  map(indices, ~ txt[.])
}

#' @importFrom purrr map map_dbl
#' @importFrom stringr str_extract str_extract_all str_remove_all str_squish
#' @importFrom tibble tibble
product_info <- function(content) {
  products <- str_remove_all(content[1], " {4,}.*")
  product <- str_remove_all(products, "^ {2,3}[\\d\\.]+ ")
  quantity <-
    products %>%
    str_extract("[\\d\\.]+") %>%
    num4()

  price_with_discounts <-
    content[1] %>%
    str_remove_all(".* {3,}") %>%
    str_extract("[-\\d\\.]+") %>%
    num4()

  if (length(content) == 1) {
    price <- price_with_discounts
    discount <- 0
    discounts_names <- NA
  } else {
    discount <-
      content[2] %>%
      str_remove_all(".* {3,}") %>%
      str_extract_all("[-\\d\\.]+") %>%
      map(num4) %>%
      map_dbl(sum)
    price <- price_with_discounts - discount
    discounts_names <-
      content[-1] %>%
      str_remove_all(" {7,}.*$") %>%
      paste0(collapse = "") %>%
      str_squish()
  }

  tibble(product = product, quantity = quantity, price = price,
         discount = discount, discounts_names = discounts_names)
}

