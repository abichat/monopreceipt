#' Read a receipt from PDF
#'
#' @inheritParams raw_receipt
#'
#' @return A tibble.
#' @export
#'
#' @importFrom tibble tibble
#'
read_receipt <- function(pdf) {
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
         total = total, discount = discount, to_pay = topay,
         purchases = list(purchases), discounts = list(discounts))
}
