test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("test example strandr", {
  ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" = c(13.191345, 23.186622), "Latitude" = c(65.834805, 70.44070))
  ex_out <- strandr(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
  expect_output(str(ex_out), "2 obs. of  11 variables")
})

test_that("test example stedsnavn", {
  ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" = c(13.191345, 23.186622), "Latitude" = c(65.834805, 70.44070))
  ex_out <- stedsnavn(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
  expect_output(str(ex_out), "2 obs. of  9 variables")
})

test_that("test example strandkoder", {
  ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" = c(13.191345, 23.186622), "Latitude" = c(65.834805, 70.44070))
  ex_out <- strandkoder(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
  expect_output(str(ex_out), "2 obs. of  5 variables")
})
