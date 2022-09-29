library(dplyr)
library(purrr)

path <- system.file("extdata/receipts", package = "monopreceipt")
pdfs <- list.files(path, pattern = ".pdf$", full.names = TRUE)

test_that("format is correct", {
  receipts <- read_receipt(pdfs)
  expect_equal(nrow(receipts), length(pdfs))
  expect_equal(receipts$total_discount == 0,
               map_lgl(receipts$discounts_detail, is.null))
})

test_that("total is correct", {
  receipts <- read_receipt(pdfs)
  total <-
    receipts$purchases_detail %>%
    map(pull, price) %>%
    map_dbl(sum)
  expect_equal(total, receipts$total)
  expect_equal(receipts$to_pay, receipts$total + receipts$total_discount)
})

test_that("discount is correct", {
  receipts <- read_receipt(pdfs)
  discount1 <-
    receipts$purchases_detail %>%
    map(pull, discount) %>%
    map_dbl(sum)
  expect_equal(discount1, receipts$total_discount)
  discount2 <-
    receipts$discounts_detail %>%
    discard(is.null) %>%
    map(pull, agg_discount) %>%
    map_dbl(sum)
  expect_equal(discount2,
               receipts$total_discount[receipts$total_discount != 0])
})
