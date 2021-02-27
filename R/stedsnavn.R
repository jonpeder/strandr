#' stedsnavn
#'
#' Returns locality data from one, or a set of input coordinates (projection longlat, datum WGS84). Locality names are obtained from the Norwegian locality-name-base (Sentralt Stedsnavnregister). For each input coordinate, the function returns the locality name  that is closest in distance. The maximum distance from a locality name is 2000 m.
#' @param lon a numerical value, or vector of numerical values, that specifies the longitude(s) in the input coordinates
#' @param lat a numerical value, or vector of numerical values, that specifies the latitude(s) in the input coordinates
#' @return dataframe with locality data
#' @examples example_output <- stedsnavn(c(69.57696, 70.44070, 62.259262), 
#' @examples                               lon = c(24.840064, 23.186622, 12.734821))
#' @import XML
#' @importFrom RCurl getURL
#' @export
stedsnavn <- function (lat, lon) {
  # output values
  output <- data.frame(lat, lon, county = "", municipality = "", locality = "", type = "", dist_m = "", orient = "")
  # Search for locality names coordinate by coordinate in a loop
  for (i in 1:length(lat)) {
    # For each coordinate, make up to 20 searches and expand the boundry box by 50 meters for each seach. Maximum distance from a locality name may be 1000 meters
    for (u in 1:40){
      # Calculate the boundry box coordinates coordinates using the deg2point function 
      x = deg2point(lat[i], lon[i], u*50, A = 225) # Lower left point of boundry box
      y = deg2point(lat[i], lon[i], u*50, A = 45) # Upper right point of boundry box
      # Search for a locality name within the given coordinates
      xURL <- paste("https://ws.geonorge.no/SKWS3Index/ssr/sok?nordLL=", x[1], "&ostLL=", x[2], "&nordUR=", y[1], "&ostUR=", y[2], "&epsgKode=", 4326, sep = "")
      xml_temp <- getURL(xURL, .encoding = "latin1")
      xml_temp2<- xmlTreeParse(xml_temp, useInternalNodes = TRUE)
      name_df <- xmlToDataFrame(xml_temp2)
      #Stop loop at first hit
      if (is.null(name_df[3,8])==FALSE) {
        break
      }
      else {
        next
      }
    }
    # extract coordinates of locality name
    name_lon <- as.numeric(name_df[3,9])
    name_lat <- as.numeric(name_df[3,10])
    # Calculate distnce and angle between input coordinates and locality-name. Use 'tryCatch' for error handeling
    tryCatch({
    D <- points2dist(name_lon, name_lat, lon[i], lat[i])
    A <- points2angle(name_lon, name_lat, lon[i], lat[i])
    # Add search results to input table
    output$county[i] <- name_df[3,7]
    output$municipality[i] <- name_df[3,6]
    output$locality[i] <- name_df[3,8]
    output$type[i] <- name_df[3,5]
    output$dist_m[i] <- round(D)
    output$orient[i] <- A
    }, error = function(e) {cat("Error:", conditionMessage(e), "\n-No locality name found within a distance of 2000 meters from coordinates on row ", i, "\n\n")})
  }
  return(output[,c(3:8)])
}
