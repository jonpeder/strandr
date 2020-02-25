# Distance in meters between two geographical points, A and B 

# A1 = Longitude point A 
# A2 = Latitude point A
# B1 = Longitude point B 
# B2 = Latitude point B


points2dist <- function(A1, A2, B1, B2) {
  # degrees to radians function
  deg2rad <- function(deg) {(deg * pi) / (180)}
  # convert degrees to radians
  Alat = deg2rad(A2) 
  Along = deg2rad(A1)
  Blat = deg2rad(B2)
  Blong = deg2rad(B1)
  # delta latitude and longitude
  dlat = sqrt((Alat-Blat)^2)
  dlong = sqrt((Along-Blong)^2)
  #Haversine formula. Earths mean radius = 6371000
  a = sin(dlat/2)^2+cos(Alat)*cos(Blat)*sin(dlong/2)^2
  c = 2*atan2(sqrt(a), sqrt(1-a))
  D = 6371000*c
  return(D)
}
