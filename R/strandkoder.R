#' Returns strand-codes
#'
#' Adds strand-codes to an input table of coordinates. The strand-codes are obtained by identifying the intesects beween the input coordinates and a polygon dataset of the Norwegian municipality borders (Anno 2012)
#' @param longlatTable (dataframe) A table containing coordinates. Georeference system must be longlat WGS84/Euref89. Longitudes and latitudes must be organized in separate rows. Whether there are additional rows of data in the dataset makes no difference.
#' @param long The specific row in the input table containing longitudes
#' @param lat The specific row in the input table containing latitudes
#' @return Returns the input dataframe with strand-codes added to it
#' @examples ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" =
#' @examples          c(24.840064, 23.186622), "Latitude" = c(69.57696, 70.44070))
#' @examples ex_out <- Strandkoder(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
#' @import sp
#' @import maptools
#' @import rgdal
#' @export
strandkoder <- function(longlatTable, long, lat) {
  # Import coordinates dataset
  longlat <- data.frame(long, lat)
  # Convert dataset from Dataframe to SpatialPoints class, with CRS wgs84
  pts <- SpatialPoints(longlat, CRS("+proj=longlat +datum=WGS84"))

  # Import Strand-codes/municipality-codes table
  strandx <- strand
  strandx$nummer <- as.character(strandx$nummer) # Change class from integer to character

  # Import municipality polygon data in geojson format
  kom_sp <- kommuner
  kom_sp$Kommunenum <- as.character(kom_sp$Kommunenum) # Change class from integer to character
  kom_ll <- spTransform(kom_sp, CRS("+proj=longlat +datum=WGS84")) # Reproject the data into longlat coordinate reference system with WGS84 datum

  # Identify municipalities intersecting with input coordinates
  ints <- data.frame(Kommunenum = "", Kommunenav = "")
  for (i in 1:length(pts)){
    if(length(kom_ll[pts[i], ]) == 1) {
      ints[i,] <- as.data.frame(kom_ll[pts[i], ])
    } else {
      ints[i,] <- NA
    }
  }

  # Cross refference municipality-codes between tables, and add municipalities and strand-codes to the input dataset
  # Add strand-codes to the dataset
  longlatTable$Strand_kode <- ""
  longlatTable$Kommune_2018 <- ""
  for (i in 1:nrow(longlatTable)) {
    if(is.na(ints$Kommunenum[i])){
      longlatTable$Strand_kode[i] <- NA
      longlatTable$Kommune_2018[i] <- NA
    } else {
      longlatTable$Strand_kode[i] <- as.vector(strandx$Strand_kode[strandx$nummer == ints$Kommunenum[i]])
      longlatTable$Kommune_2018[i] <- as.vector(strandx$Gammel_kommune[strandx$nummer == ints$Kommunenum[i]])
    }
  }
  return(longlatTable)
}
