
library(stars)
library(sf)

path_name <- "E:/Sentinel3Work/New_Data/DesertRock/LST/unzip/S3A_SL_2_LST____20210401T181454_20210401T181754_20210403T040122_0179_070_141_2340_LN2_O_NT_004.SEN3"

#set directory
setwd(path_name)


nc_fileName <- "LST_in.nc"
file_variable <- "LST"


output_fileName1 <- sub("\\..*", "", nc_fileName)
output_fileName <- paste0(file_variable, ".tif")
# Manually add projection information (modify the proj4string accordingly)
projection <- st_crs("+proj=longlat +datum=WGS84")
# Read NetCDF file of geo reference
coords <- read_ncdf("geodetic_in.nc", var = c("latitude_in", "longitude_in"))
st_crs(coords) <- projection
lats <- coords$latitude_in
lons <- coords$longitude_in
lst <- read_ncdf(nc_fileName, var = file_variable)
st_crs(lst) <- projection

##for others
# lst <- lst$sat_zenith_tn
lst <- lst[[file_variable]]
lst <- st_as_stars(lst)
lst <- st_as_stars(lst, curvilinear = list(X1 = lons, X2 = lats))

lst_warp = st_warp(lst, crs = "EPSG:4326", cellsize = 0.01, threshold = 0.02)

write_stars(lst_warp, output_fileName)
