# Function for calculating the angle of geographical point A relative to point B. 

# A1 = Long point A 
# A2 = Lat point A
# B1 = Long point B 
# B2 = Lat point B


points2angle <- function(A1, A2, B1, B2) {
  # Degrees radians converter functions
  deg2rad <- function(deg) {(deg * pi) / 180}
  rad2deg <- function(rad) {(rad*180) / pi}
  # Convert degrees to radians
  Alat = deg2rad(A2)
  Blat = deg2rad(B2)
  # calculate delta longitude
  dlong = deg2rad(B1-A1)
  # Find quantities for X and Y
  X <- cos(Blat)*sin(dlong)
  Y <- cos(Alat)*sin(Blat)-sin(Alat)*cos(Blat)*cos(dlong)
  # Calculate bearing point
  B <- atan2(X, Y)
  D1 <- rad2deg(B)
  if (D1 < 0) {
    D <- D1 + 360
  } else {
      D <- D1
  }

  # Convert angle to Orientation
  if (D <= 22.5 | D > 337.5) {
    return("N")
  }
  if (D >= 22.5 & D < 67.5) {
    return("NE")
  }
  if (D >= 67.5 & D < 112.5) {
    return("E")
  }
  if (D >= 112.5 & D < 157.5) {
    return("SE")
  }
  if (D >= 157.5 & D < 202.5) {
    return("S")
  }
  if (D >= 202.5 & D < 247.5) {
    return("SW")
  }
  if (D >= 247.5 & D < 292.5) {
    return("W")
  }
  if (D >= 292.5 & D < 337.5) {
    return("NW")
  }
}