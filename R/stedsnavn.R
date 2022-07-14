#' stedsnavn
#'
#' Returns locality data from one, or a set of input coordinates (projection longlat, datum WGS84). Locality names are obtained from the Norwegian locality-name-base (Sentralt Stedsnavnregister). For each input coordinate, the function returns the locality name  that is closest in distance. The maximum distance from a locality name is 2000 m.
#' @param lon a numerical value, or vector of numerical values, that specifies the longitude(s) in the input coordinates
#' @param lat a numerical value, or vector of numerical values, that specifies the latitude(s) in the input coordinates
#' @return dataframe with locality data
#' @examples example_output <- stedsnavn(lat = c(69.57696, 70.44070, 62.259262), lon = c(24.840064, 23.186622, 12.734821))
#' @import curl
#' @importFrom jsonlite fromJSON
#' @export

stedsnavn <- function (lat, lon) {
  # output values
  output <- data.frame(lat, lon, locality = "", type = "", dist_m = "", orient = "")
  # Search for locality names coordinate by coordinate in a loop
  for (i in 1:length(lat)) {
    # Prepare URL for the locality name search
    stedsnavn_url = paste0("https://ws.geonorge.no/stedsnavn/v1/punkt?nord=", lat[i], "&ost=", lon[i], "&koordsys=4326&radius=2000&utkoordsys=4326&treffPerSide=200&side=1")
    # Make the API call
    stedsnavn_api = fromJSON(stedsnavn_url)
    # If API search is empty, return empty result
    if (is.null(nrow(stedsnavn_api$navn))) {
        output$locality[i] = ""
        output$type[i] = ""
        output$dist_m[i] = ""
        output$orient[i] = ""
    } else {
        tryCatch({
        # Give "Adressenavn" a high distance
        stedsnavn_api$navn$meterFraPunkt[stedsnavn_api$navn$navneobjekttype == "Adressenavn"] = 10000
        # Use locality with shortet distance to point
        n = order(stedsnavn_api$navn$meterFraPunkt)[1]
        output$locality[i] = stedsnavn_api$navn$stedsnavn[[n]][1,1]
        output$type[i] = stedsnavn_api$navn$navneobjekttype[n]
        # Extract coordinates of locality name
        name_lat <- stedsnavn_api$navn$representasjonspunkt[n,2]
        name_lon <- stedsnavn_api$navn$representasjonspunkt[n,1]
        # Calculate distnce and angle between input coordinates and locality-name. Use 'tryCatch' for error handeling
        output$dist_m[i] <- round(points2dist(name_lon, name_lat, lon[i], lat[i]))
        output$orient[i] <- points2deg(name_lon, name_lat, lon[i], lat[i])
        }, error = function(e) {cat("Error:", conditionMessage(e), "\n-No locality name found within a distance of 2000 meters from coordinates on row ", i, "\n\n")})
    }
  }
  return(output[,c(3:6)])
}