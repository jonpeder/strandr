# deg2point, Jon Peder Lindemann, 26.02.2021
# Get coordinates for a point B from a given angle, distance and coordinates of point A
# Parameters:
# lat | latitude
# lon | longitude
# d | distance in meters
# A | bearing (angle from point 1 to point 2 clockwise relative to north)

deg2point <- function(lat, lon, d, A) {
  R = 6371000 # Earth radius
  Ad = d/R # Angular distance
  
  # Functions for converting between deg and rad
  deg2rad <- function(deg) {(deg * pi) / (180)}
  rad2deg <- function(rad) {(rad * 180) / (pi)}
  # Convert deg to rad
  lon = deg2rad(lon)
  lat = deg2rad(lat)
  A = deg2rad(A)
  
  # Calculate B1 and B2
  B1 = asin(sin(lat)*cos(Ad) + cos(lat)*sin(Ad)*cos(A))
  B2 = lon + atan2(sin(A)*sin(Ad)*cos(lat), cos(Ad) - sin(lat)*sin(B1))
  # Convert rad to deg
  B1 = rad2deg(B1)
  B2 = rad2deg(B2)
  B1
  B2
  # return point
  return (c(B1,B2))
}
