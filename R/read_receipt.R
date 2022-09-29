#' Read a receipt from PDF
#'
#' @details `read_receipt` is vectorised over `pdf`.
#'
#' @inheritParams raw_receipt
#'
#' @return A tibble.
#' @export
#'
#' @importFrom purrr map_dfr
#'
read_receipt <- function(pdf) {
  map_dfr(pdf, read_receipt_one)
}


#' @importFrom tibble tibble
read_receipt_one <- function(pdf) {
  raw <- raw_receipt(pdf)
  v_date <- get_date(raw)
  v_address <- get_address(raw)
  client <- get_client(raw)
  total <- get_total(raw)
  discount <- get_discount(raw)
  topay <- get_topay(raw)
  purchases <- get_purchases(raw)
  discounts <- get_discounts(raw)
  tibble(date = v_date[1], time = v_date[2],
         address = v_address[1], city = v_address[2], client = client,
         total = total, total_discount = discount, to_pay = topay,
         purchases_detail = list(purchases),
         discounts_detail = list(discounts))
}
