library(devtools)
library(usethis)
library(testthat)

# use_build_ignore("dev_history.R")

# use_gpl3_license()

# use_r("raw")

# use_pipe()

# use_r("parts")

# use_r("between")

# use_r("helpers")

# use_r("helpers_purchases")

# use_r("read_receipt")

# use_testthat()

# use_test("receipt")

# use_readme_rmd()


####

devtools::load_all()

devtools::document()

attachment::att_amend_desc()

usethis::use_tidy_description()

devtools::check()

goodpractice::goodpractice()
