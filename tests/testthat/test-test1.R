test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("test example Insektlok", {
  ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" = c(24.840064, 23.186622), "Latitude" = c(69.57696, 70.44070))
  ex_out <- Insektlok(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
  expect_output(str(ex_out), "2 obs. of  10 variables")
})

test_that("test example Stedsnavn", {
  ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" = c(24.840064, 23.186622), "Latitude" = c(69.57696, 70.44070))
  ex_out <- Stedsnavn(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
  expect_output(str(ex_out), "2 obs. of  8 variables")
})

test_that("test example Strandkoder", {
  ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" = c(24.840064, 23.186622), "Latitude" = c(69.57696, 70.44070))
  ex_out <- Strandkoder(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
  expect_output(str(ex_out), "2 obs. of  5 variables")
})
