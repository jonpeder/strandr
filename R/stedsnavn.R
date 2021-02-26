#' stedsnavn
#'
#' Returns locality data from one, or a set of input coordinates (projection longlat, datum WGS84). Locality names are obtained from the Norwegian locality-name-base (Sentralt Stedsnavnregister). For each input coordinate, the function returns the locality name  that is closest in distance. The maximum distance from a locality name is 1000 m.
#' @param lon a numerical value, or vector of numerical values, that specifies the longitude(s) in the input coordinates
#' @param lat a numerical value, or vector of numerical values, that specifies the latitude(s) in the input coordinates
#' @return dataframe with locality data
#' @examples example_output <- strandkoder(lon = c(24.840064, 23.186622), 
#' @examples                               lat = c(69.57696, 70.44070))
#' @import XML
#' @importFrom RCurl getURL
#' @export
stedsnavn <- function (lon, lat) {
  
  # output values
  output <- data.frame(lon,
                       lat,
                       county = "", 
                       municipality = "", 
                       locality = "", 
                       type = "", 
                       dist_m = "",
                       orient = "")
  # Loop over input coordinates
  for (i in 1:length(lon)) {
    # add longitude and latitude to new variables
    x = lat[i]
    y = lon[i]

    # Define boundary box
    x1 = x # Lower left N coordinate
    y1 = y # Lower left E coordinate
    x2 = x # Upper Right N coordinate
    y2 = y # Upper Right E coordinate

    Loc_df <- NULL
    for (q in 1:50){
      # Expand target area by some degrees in each direction. Longitudes 3*latitudes to make the increase more or less square-like.
      x1 = (x1*10^4-6)/10^4
      y1 = (y1*10^4-17)/10^4
      x2 = (x2*10^4+6)/10^4
      y2 = (y2*10^4+17)/10^4
      # Search for a locality name within the given coordinates
      xURL <- paste("https://ws.geonorge.no/SKWS3Index/ssr/sok?nordLL=", x1, "&ostLL=", y1, "&nordUR=", x2, "&ostUR=", y2, "&epsgKode=", 4258, sep = "")
      xml_temp <- getURL(xURL, .encoding = "latin1")
      xml_temp2<- xmlTreeParse(xml_temp, useInternalNodes = TRUE)
      Loc_df <- xmlToDataFrame(xml_temp2)
      #Stop loop at first hit
      if (is.null(Loc_df[3,8])==FALSE) {
        break
      }
      else {
        next
      }
    }
    # Calculate distnce and angle between input coordinates and locality-name
    A <- as.numeric(Loc_df[3,9])
    B <- as.numeric(Loc_df[3,10])
    D <- points2dist(A, B, y, x)
    A <- points2angle(A, B, y, x)
    
    # Add search results to input table
    output$county[i] <- Loc_df[3,7]
    output$municipality[i] <- Loc_df[3,6]
    output$locality[i] <- Loc_df[3,8]
    output$type[i] <- Loc_df[3,5]
    output$dist_m[i] <- round(D)
    output$orient[i] <- A
  }
  return(output[,c(3:8)])
}
