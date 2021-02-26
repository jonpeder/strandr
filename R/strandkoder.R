#' strandkoder
#'
#' Returns Strand-codes from one, or a set of input coordinates (projection longlat, datum WGS84). The strand-codes are obtained by identifying the intesects beween the input coordinates and a polygon dataset of the Strand regions. This dataset was created by Endrestøl (2021), following the revision of the Strand-system by Økland (1981).
#' @param lon a numerical value, or vector of numerical values, that specifies the longitude(s) in the input coordinates
#' @param lat a numerical value, or vector of numerical values, that specifies the latitude(s) in the input coordinates
#' @return dataframe with Strand-codes
#' @examples example_output <- strandkoder(lon = c(24.840064, 23.186622), 
#' @examples                               lat = c(69.57696, 70.44070))
#' @import sp
#' @export
strandkoder <- function(lon, lat) {
  # Save longlat projection to variable
  ll_prj <- "+proj=longlat +datum=WGS84"
  # Import coordinates dataset
  lonlat <- data.frame(lon, lat)
  # Convert decimal-longlat to SpatialPoints class, with projection longlat datum wgs84
  pts <- SpatialPoints(lonlat, CRS(ll_prj))
  # Convert 'strand' spatial polygons dataframe to projection longlat and datum wgs84
  strand.4.0 <- spTransform(strand, CRS(ll_prj))
  # Identify municipalities intersecting with input coordinates
  strand_codes <- over(pts, strand.4.0)
  # Return dataframe
  return(data.frame(strand = strand_codes[,2]))
}
