#' strandr
#'
#' Returns Strand-codes and locality data from one, or a set of input coordinates (projection longlat, datum WGS84). The strand-codes are obtained by identifying the intesects beween the input coordinates and a polygon dataset of the Strand regions. Locality names are obtained from the Norwegian locality-name-base (Sentralt Stedsnavnregister). For each input coordinate, the function returns the locality name  that is closest in distance. The maximum distance from a locality name is 2000 m.
#' @param table_input a table to which the returned data will be added
#' @param lon a numerical value, or vector of numerical values, that specifies the longitude(s) in the input coordinates
#' @param lat a numerical value, or vector of numerical values, that specifies the latitude(s) in the input coordinates
#' @return dataframe with Strand-codes and locality data
#' @examples example_input <- data.frame("COL_ID" = c("JPL_0051", "JPL_0052", "JPL_0053"), 
#' @examples                             "Latitude" = c(69.57696, 70.44070, 62.259262),
#' @examples                             "Longitude" = c(24.840064, 23.186622, 12.734821))
#' @examples example_output <- strandr(example_input, 
#' @examples                           lat = example_input$Latitude, 
#' @examples                           lon = example_input$Longitude)
#' @export
strandr <- function(table_input = "", lat, lon) {

  # Get Strand-codes
  strand_codes <- strandkoder(lat, lon)
  # Get locality data
  locality_data <- stedsnavn(lat, lon)
  # Add Strand-codes and locality data to input table
  table_input <- data.frame(table_input, strand_codes, locality_data)
    
  return(table_input)
}
