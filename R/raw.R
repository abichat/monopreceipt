#' Read receipt from PDF
#'
#' @param pdf File path or raw vector with pdf data.
#'
#' @return A
#' @export
#'
#' @importFrom pdftools pdf_text
#' @importFrom purrr map
#' @importFrom stringr str_split
#'
raw_receipt <- function(pdf) {
  pdf_text(pdf) %>%
    map(str_split, pattern = "\n") %>%
    unlist()
}
