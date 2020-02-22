#' Returns insect locality data
#'
#' Adds locality data to an input table of coordinates. Locality data is obtained from the Norwegian locality-name-base, Sentralt Stedsnavnregister (SSR). Outputs the closest locality data  for each spatial point of an input table of coordinates (Longlat).Maximum distance from locality name is set to ~ 1000 m, due to computing time
#' @param z (dataframe) A table containing coordinates. Georeference system must be longlat WGS84/Euref89. Longitudes and latitudes must be organized in separate rows. Whether there are additional rows of data in the dataset makes no difference.
#' @param long The specific row in the input table containing longitudes
#' @param lat The specific row in the input table containing latitudes
#' @return Returns the input dataframe with locality data added to it
#' @examples ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" =
#' @examples          c(24.840064, 23.186622), "Latitude" = c(69.57696, 70.44070))
#' @examples ex_out <- Stedsnavn(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
#' @import XML
#' @import RCurl
#' @export
Stedsnavn <- function (z, long, lat) {

  # Variables
  z$Fylke <- ""
  z$Kommune <- ""
  z$Sted <- ""
  z$Type <- ""
  z$Dist_m <- ""

  for (i in 1:nrow(z)) {
    # Insert lat long
    x = lat[i]
    y = long[i]

    # Define boundary box
    x1 = x # Lower left N coordinate
    y1 = y # Lower left E coordinate
    x2 = x # Upper Right N coordinate
    y2 = y # Upper Right E coordinate

    Loc_df <- NULL
    for (q in 1:50){
      # Expand target area by 1 in each direction
      x1 = (x1*10^4-5)/10^4
      y1 = (y1*10^4-5)/10^4
      x2 = (x2*10^4+5)/10^4
      y2 = (y2*10^4+5)/10^4
      # Search for a locality name within the given coordinates
      xURL <- paste("https://ws.geonorge.no/SKWS3Index/ssr/sok?nordLL=", x1, "&ostLL=", y1, "&nordUR=", x2, "&ostUR=", y2, "&epsgKode=", 4258, sep = "")
      xml_temp <- getURL(xURL, .encoding = "latin1")
      xml_temp2<- xmlTreeParse(xml_temp, useInternalNodes = TRUE)
      Loc_df <- xmlToDataFrame(xml_temp2)
      #Stop loop at first hit
      if (is.null(Loc_df[3,8])==FALSE) {
        count <- q
        break
      }
      else {
        next
      }
    }

    # Add search results to input table

    z$Fylke[i] <- Loc_df[3,7]
    z$Kommune[i] <- Loc_df[3,6]
    z$Sted[i] <- Loc_df[3,8]
    z$Type[i] <- Loc_df[3,5]
    z$Dist_m[i] <- count*20
  }
  return(z)
}
