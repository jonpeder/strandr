test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("test example strandr", {
  ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Latitude" = c(65.834805, 70.44070), "Longitude" = c(13.191345, 23.186622))
  ex_out <- strandr(ex_in, lat = ex_in$Latitude, lon = ex_in$Longitude)
  expect_output(str(ex_out), "2 obs. of  10 variables")
})

test_that("test example stedsnavn", {
  ex_out <- stedsnavn(lat = c(65.834805, 70.44070), lon = c(13.191345, 23.186622))
  expect_output(str(ex_out), "2 obs. of  4 variables")
})

test_that("test example strandkoder", {
  ex_out <- strandkoder(lat = c(65.834805, 70.44070), lon = c(13.191345, 23.186622))
  expect_output(str(ex_out), "2 obs. of  3 variables")
})
