%let pgm=utl-converting-us-gps-decimal-latitude-and-longitude-to-census-zcta-zipcodes-geocode;

%stop_submission;

Converting us gps decimal latitude and longitude to census zcta zipcodes

SOAPBOX ON

You need to learn how to use sf language(spatial analysis) in r and python.
I think it is worth it.
The r and python packages complement sas.

USPS ZIP Codes are designed for mail delivery efficiency and can change frequently,
while Census ZCTAs are approximations of ZIP Code areas used for
demographic and statistical purposes, offering more geographic stability
but less precision in matching actual delivery routes.

NAD83 ,Coordinate Reference System (CRS), is coincident with the more common WGS 84?

Process is slow,I suggest 32 parallel processes? My $600 system suppots this.

SOAPBOX OFF

   CONTENTS
   ========

     INPUTS
       1 download zcta polygons (68mb)
       2 create sample input lat longs

     PROCESS
       3.intersect lat lon with  zcta polygons

       4 related repos

github
https://tinyurl.com/ypc79pdx
https://github.com/rogerjdeangelis/utl-converting-us-gps-decimal-latitude-and-longitude-to-census-zcta-zipcodes-geocode


/**************************************************************************************************************************/
/*             INPUTS                             |             PROCESS                      |        OUTPUT              */
/*             =======                            |             ========                     |        ======              */
/*                                                |                                          |                            */
/*  CENSUS 2020 ZCTA POLYGONS                     | 3.INTERSECT LAT LON WITHZCTA POLYGONS    | R                          */
/*  (UPDATED WITH 10YR CENSUS)                    | =======================================  |                            */
/*                                                |                                          | ZCTA5CE20   lon      lat   */
/*  d:/rds/zcta2020.rds  3,791 records and 64mb)  | %utl_rbeginx;                            |                            */
/*                                                | parmcards4;                              |  85750 -110.85959 32.30440 */
/*  Autatically downloaded by r                   | library(haven)                           |  40291  -85.56570 38.09107 */
/*  and saved in file d:/rds/zcta2020.rds         | library(tigris)                          |  92677 -117.70471 33.55998 */
/*                                                | library(sf)                              |  02767  -71.04260 41.92892 */
/*  Simple feature collection                     | source("c:/oto/fn_tosas9x.R")            |  12180  -73.67012 42.73710 */
/*  with 33791 features and 7 fields              | have<-read_sas("d:/sd1/have.sas7bdat")   |  02744  -70.92210 41.61570 */
/*                                                | have                                     |  92503 -117.48399 33.87170 */
/*  d:/rds/zcta2020.rds                           | zctas <- readRDS("d:/rds/zcta2020.rds")  |  14217  -78.86896 42.96206 */
/*                                                | str(zctas)                               |  95123 -121.83024 37.24261 */
/*  ZCTA0  ... geometry                           | print(zctas)                             |  92843 -117.94868 33.75759 */
/*                                                | st_crs(have)                             |  60615  -87.60896 41.80330 */
/*  15301  ...  MULTIPOLYGON (((-80.3686 40...    | points <- st_as_sf(have                  |  94536 -122.00228 37.54401 */
/*  15658  ...  MULTIPOLYGON (((-79.34323 4...    |  ,coords = c("LONGITUDE", "LATITUDE")    |                            */
/*  15601  ...  MULTIPOLYGON (((-79.66911 4...    |  ,crs = "NAD83")                         |                            */
/*  17720  ...  MULTIPOLYGON (((-77.23026 4...    | st_crs(points)                           | SAS                        */
/*  18843  ..   MULTIPOLYGON (((-75.90554 4...    | st_crs(zctas)                            |                            */
/*  ...                                           | result <- st_join(points, zctas)         | ZCTA5CE20  LON        LAT  */
/*                                                | coords <- st_coordinates(result)         |                            */
/*  1 DOWNLOAD ZCTA POLYGONS (68MB)               | result$lon <- coords[,1]                 | 85750 -110.860    32.3044 A*/
/*  ===============================               | result$lat <- coords[,2]                 | 40291  -85.566    38.0911 B*/
/*                                                | result$lat <- coords[,2]                 | 92677 -117.705    33.5600 C*/
/*  %utl_rbeginx;                                 | result <- st_drop_geometry(result)       | 02767  -71.043    41.9289 D*/
/*  parmcards4;                                   | result=data.frame(result[,c(1,8,9)])     | 12180  -73.670    42.7371  */
/*  library(tigris)                               | result                                   | 02744  -70.922    41.6157  */
/*  zcta_data <- zctas(year = 2020, cb = TRUE)    | fn_tosas9x(                              | 92503 -117.484    33.8717  */
/*  saveRDS(zcta_data,"d:/rds/zcta2020.rds")      |       inp    = result                    | 14217  -78.869    42.9621  */
/*  result;                                       |      ,outlib ="d:/sd1/"                  | 95123 -121.830    37.2426  */
/*  ;;;;                                          |      ,outdsn ="want"                     | 92843 -117.949    33.7576  */
/*  %utl_rendx;                                   |      )                                   | 60615  -87.609    41.8033  */
/*                                                | ;;;;                                     | 94536 -122.002    37.5440  */
/*                                                | %utl_rendx;                              |                            */
/*  2 CREATE SAMPLE INPUT LAT LONGS               |                                          |                            */
/*  ===============================               | proc print data=sd1.want;                | CHECK FIRST 4              */
/*                                                | run;quit;                                | https://www.geocords.com/  */
/*   LONGITUDE    LATITUDE                        |                                          | =========================  */
/*                                                |                                          |                            */
/*    -110.860     32.3044                        |                                          |                            */
/*     -85.566     38.0911                        |                                          | A: 5349 N Fort Yuma Trail, */
/*    -117.705     33.5600                        |                                          |   Tucson, AZ               */
/*     -71.043     41.9289                        |                                          |   85750, USA               */
/*     -73.670     42.7371                        |                                          |                            */
/*     -70.922     41.6157                        |                                          | B:11604 Expedition Trail,  */
/*    -117.484     33.8717                        |                                          |   Louisville, KY           */
/*     -78.869     42.9621                        |                                          |   40291, USA               */
/*    -121.830     37.2426                        |                                          |                            */
/*    -117.949     33.7576                        |                                          | C: 27712 Agate Canyon Dr,  */
/*     -87.609     41.8033                        |                                          |   Laguna , CA              */
/*    -122.002     37.5440                        |                                          |   92677, USA               */
/*                                                |                                          |                            */
/*                                                |                                          | D: 320 Pleasant St,        */
/*  options validvarname=upcase;                  |                                          |   Raynham, MA              */
/*  libname sd1 "d:/sd1";                         |                                          |   02767, USA               */
/*  data sd1.have;                                |                                          |                            */
/*  informat longitude latitude 13.6;             |                                          |                            */
/*  format longitude latitude 13.6;               |                                          |                            */
/*  input longitude latitude;                     |                                          |                            */
/*  cards4;                                       |                                          |                            */
/*  -110.85959 32.304404                          |                                          |                            */
/*  -85.565702 38.091068                          |                                          |                            */
/*  -117.704708 33.559975                         |                                          |                            */
/*  -71.042603 41.928917                          |                                          |                            */
/*  -73.670121 42.737101                          |                                          |                            */
/*  -70.922099 41.615695                          |                                          |                            */
/*  -117.483986 33.871702                         |                                          |                            */
/*  -78.868959 42.962064                          |                                          |                            */
/*  -121.830240 37.242610                         |                                          |                            */
/*  -117.948680 33.757590                         |                                          |                            */
/*  -87.608957 41.803302                          |                                          |                            */
/*  -122.002276 37.544014                         |                                          |                            */
/*  ;;;;                                          |                                          |                            */
/*  run;quit;                                     |                                          |                            */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_ ___
| | `_ \| `_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|
 _       _                     _                 _           _                     _
/ |   __| | _____      ___ __ | | ___   __ _  __| |  _______| |_ __ _  _ __   ___ | |_   _  __ _  ___  _ __  ___
| |  / _` |/ _ \ \ /\ / / `_ \| |/ _ \ / _` |/ _` | |_  / __| __/ _` || `_ \ / _ \| | | | |/ _` |/ _ \| `_ \/ __|
| | | (_| | (_) \ V  V /| | | | | (_) | (_| | (_| |  / / (__| || (_| || |_) | (_) | | |_| | (_| | (_) | | | \__ \
|_|  \__,_|\___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_| /___\___|\__\__,_|| .__/ \___/|_|\__, |\__, |\___/|_| |_|___/
                                                                      |_|            |___/ |___/
*/

* DOWNLOAD ONCE TO SAVE TIME ON FUTURE RUNS;

%utl_rbeginx;
parmcards4;
library(tigris)
zcta_data <- zctas(year = 2020, cb = TRUE)
saveRDS(zcta_data,"d:/rds/zcta2020.rds")
;;;;
%utl_rendx;

/**************************************************************************************************************************/
/* d:/rds/zcta2020.rds                                                                                                    */
/*                                                                                                                        */
/* Simple feature collection with 33791 features and 7 fields                                                             */
/* Geometry type: MULTIPOLYGON                                                                                            */
/* Dimension:     XY                                                                                                      */
/* Bounding box:  xmin: -176.6967 ymin: -14.37374 xmax: 145.8304 ymax: 71.34122                                           */
/* Geodetic CRS:  NAD83                                                                                                   */
/* First 10 features:                                                                                                     */
/*                                                                                                                        */
/*    ZCTA5CE20     AFFGEOID20 GEOID20 NAME20 LSAD20   ALAND20 AWATER20                        GEOMETRY                   */
/*                                                                                                                        */
/* 1      15301 860Z200US15301   15301  15301     Z5 315861121   709775  MULTIPOLYGON (((-80.3686 40...                   */
/* 2      15658 860Z200US15658   15658  15658     Z5 238683518   759690  MULTIPOLYGON (((-79.34323 4...                   */
/* 3      15601 860Z200US15601   15601  15601     Z5 208874774   337008  MULTIPOLYGON (((-79.66911 4...                   */
/* 4      17720 860Z200US17720   17720  17720     Z5   8797202     2822  MULTIPOLYGON (((-77.23026 4...                   */
/* 5      18843 860Z200US18843   18843  18843     Z5   3620019        0  MULTIPOLYGON (((-75.90554 4...                   */
/* 6      30114 860Z200US30114   30114  30114     Z5 246536321 17044903  MULTIPOLYGON (((-84.65791 3...                   */
/* 7      30281 860Z200US30281   30281  30281     Z5 179405961  2749692  MULTIPOLYGON (((-84.29878 3...                   */
/* 8      31044 860Z200US31044   31044  31044     Z5 391881329   970277  MULTIPOLYGON (((-83.48153 3...                   */
/* 9      31419 860Z200US31419   31419  31419     Z5 188809990 15139094  MULTIPOLYGON (((-81.38473 3...                   */
/* 10     30137 860Z200US30137   30137  30137     Z5   8264947        0  MULTIPOLYGON (((-84.79026 3...                   */
/* ....                                                                                                                   */
/*                                                                                                                        */
/* LOG                                                                                                                    */
/*                                                                                                                        */
/* > library(tigris)                                                                                                      */
/* > zcta_data <- zctas(year = 2020, cb = TRUE)                                                                           */
/* > saveRDS(zcta_data,"d:/rds/zcta2020.rds")                                                                             */
/* >                                                                                                                      */
/* Stderr output:                                                                                                         */
/* To enable caching of data, set `options(tigris_use_cache = TRUE)                                                       */
/* in your R script or .Rprofile                                                                                          */
/* Warning message                                                                                                        */
/* package 'tigris' was built under R version 4.4.2                                                                       */
/* ZCTAs can take several minutes to download.                                                                            */
/* To cache the data and avoid re-downloading in                                                                          */
/* future R sessions, set `options(tigris_use_cache = TRUE)                                                               */
/**************************************************************************************************************************/

/*___                        _                                   _       _                   _
|___ \    ___ _ __ ___  __ _| |_ ___   ___  __ _ _ __ ___  _ __ | | ___ (_)_ __  _ __  _   _| |_
  __) |  / __| `__/ _ \/ _` | __/ _ \ / __|/ _` | `_ ` _ \| `_ \| |/ _ \| | `_ \| `_ \| | | | __|
 / __/  | (__| | |  __/ (_| | ||  __/ \__ \ (_| | | | | | | |_) | |  __/| | | | | |_) | |_| | |_
|_____|  \___|_|  \___|\__,_|\__\___| |___/\__,_|_| |_| |_| .__/|_|\___||_|_| |_| .__/ \__,_|\__|
                                                          |_|                   |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
informat longitude latitude 13.6;
format longitude latitude 13.6;
input longitude latitude;
cards4;
-110.85959 32.304404
-85.565702 38.091068
-117.704708 33.559975
-71.042603 41.928917
-73.670121 42.737101
-70.922099 41.615695
-117.483986 33.871702
-78.868959 42.962064
-121.830240 37.242610
-117.948680 33.757590
-87.608957 41.803302
-122.002276 37.544014
;;;;
run;quit;

/**************************************************************************************************************************/
/*  SD1.HAVE                                                                                                              */
/*                                                                                                                        */
/*  LONGITUDE    LATITUDE                                                                                                 */
/*                                                                                                                        */
/*   -110.860     32.3044                                                                                                 */
/*    -85.566     38.0911                                                                                                 */
/*   -117.705     33.5600                                                                                                 */
/*    -71.043     41.9289                                                                                                 */
/*    -73.670     42.7371                                                                                                 */
/*    -70.922     41.6157                                                                                                 */
/*   -117.484     33.8717                                                                                                 */
/*    -78.869     42.9621                                                                                                 */
/*   -121.830     37.2426                                                                                                 */
/*   -117.949     33.7576                                                                                                 */
/*    -87.609     41.8033                                                                                                 */
/*   -122.002     37.5440                                                                                                 */
/**************************************************************************************************************************/

/*____   _       _                          _     _       _     _                       _ _   _                 _
|___ /  (_)_ __ | |_ ___ _ __ ___  ___  ___| |_  | | __ _| |_  | | ___  _ __  __      _(_) |_| |__  _ __   ___ | |_   _  __ _  ___  _ __  ___
  |_ \  | | `_ \| __/ _ \ `__/ __|/ _ \/ __| __| | |/ _` | __| | |/ _ \| `_ \ \ \ /\ / / | __| `_ \| `_ \ / _ \| | | | |/ _` |/ _ \| `_ \/ __|
 ___) | | | | | | ||  __/ |  \__ \  __/ (__| |_  | | (_| | |_  | | (_) | | | | \ V  V /| | |_| | | | |_) | (_) | | |_| | (_| | (_) | | | \__ \
|____/  |_|_| |_|\__\___|_|  |___/\___|\___|\__| |_|\__,_|\__| |_|\___/|_| |_|  \_/\_/ |_|\__|_| |_| .__/ \___/|_|\__, |\__, |\___/|_| |_|___/
                                                                                                   |_|            |___/ |___/
*/

%utl_rbeginx;
parmcards4;
library(haven)
library(tigris)
library(sf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
have
zctas <- readRDS("d:/rds/zcta2020.rds")
str(zctas)
print(zctas)
st_crs(have)
points <- st_as_sf(have
 ,coords = c("LONGITUDE", "LATITUDE")
 ,crs = "NAD83")
st_crs(points)
st_crs(zctas)
result <- st_join(points, zctas)
coords <- st_coordinates(result)
result$lon <- coords[,1]
result$lat <- coords[,2]
result$lat <- coords[,2]
result <- st_drop_geometry(result)
result=data.frame(result[,c(1,8,9)])
result
fn_tosas9x(
      inp    = result
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* R                                  |  SAS                                                                              */
/* > result                           |  SD1.WANT                                                                         */
/*                                    |                                                                                   */
/*    ZCTA5CE20        lon      lat   |  ROWNAMES    ZCTA5CE20       LON        LAT                                       */
/*                                    |                                                                                   */
/* 1      85750 -110.85959 32.30440   |      1         85750      -110.860    32.3044                                     */
/* 2      40291  -85.56570 38.09107   |      2         40291       -85.566    38.0911                                     */
/* 3      92677 -117.70471 33.55998   |      3         92677      -117.705    33.5600                                     */
/* 4      02767  -71.04260 41.92892   |      4         02767       -71.043    41.9289                                     */
/* 5      12180  -73.67012 42.73710   |      5         12180       -73.670    42.7371                                     */
/* 6      02744  -70.92210 41.61570   |      6         02744       -70.922    41.6157                                     */
/* 7      92503 -117.48399 33.87170   |      7         92503      -117.484    33.8717                                     */
/* 8      14217  -78.86896 42.96206   |      8         14217       -78.869    42.9621                                     */
/* 9      95123 -121.83024 37.24261   |      9         95123      -121.830    37.2426                                     */
/* 10     92843 -117.94868 33.75759   |     10         92843      -117.949    33.7576                                     */
/* 11     60615  -87.60896 41.80330   |     11         60615       -87.609    41.8033                                     */
/* 12     94536 -122.00228 37.54401   |     12         94536      -122.002    37.5440                                     */
/* -----------------------------------------------------------------------------------------------------------------------*/
/*                                                                                                                        */
/* LOG                                                                                                                    */
/* ===                                                                                                                    */
/* > library(haven)                                                                                                       */
/*                                                                                                                        */
/* > library(tigris)                                                                                                      */
/* > library(sf)                                                                                                          */
/* > source("c:/oto/fn_tosas9x.R")                                                                                        */
/* > have<-read_sas("d:/sd1/have.sas7bdat")                                                                               */
/* > have                                                                                                                 */
/* # A tibble: 12 Ã— 2                                                                                                    */
/*    LONGITUDE LATITUDE                                                                                                  */
/*        <dbl>    <dbl>                                                                                                  */
/*  1    -111.      32.3                                                                                                  */
/*  2     -85.6     38.1                                                                                                  */
/*  3    -118.      33.6                                                                                                  */
/*  4     -71.0     41.9                                                                                                  */
/*  5     -73.7     42.7                                                                                                  */
/*  6     -70.9     41.6                                                                                                  */
/*  7    -117.      33.9                                                                                                  */
/*  8     -78.9     43.0                                                                                                  */
/*  9    -122.      37.2                                                                                                  */
/* 10    -118.      33.8                                                                                                  */
/* 11     -87.6     41.8                                                                                                  */
/* 12    -122.      37.5                                                                                                  */
/* > zctas <- readRDS("d:/rds/zcta2020.rds")                                                                              */
/* > str(zctas)                                                                                                           */
/* Classes 'sf' and 'data.frame':  33791 obs. of  8 variables:                                                            */
/*  $ ZCTA5CE20 : chr  "15301" "15658" "15601" "17720" ...                                                                */
/*  $ AFFGEOID20: chr  "860Z200US15301" "860Z200US15658" "860Z200US15601" "860Z200US17720" ...                            */
/*  $ GEOID20   : chr  "15301" "15658" "15601" "17720" ...                                                                */
/*  $ NAME20    : chr  "15301" "15658" "15601" "17720" ...                                                                */
/*  $ LSAD20    : chr  "Z5" "Z5" "Z5" "Z5" ...                                                                            */
/*  $ ALAND20   : num  3.16e+08 2.39e+08 2.09e+08 8.80e+06 3.62e+06 ...                                                   */
/*  $ AWATER20  : num  709775 759690 337008 2822 0 ...                                                                    */
/*  $ geometry  :sfc_MULTIPOLYGON of length 33791; first list element: List of 1                                          */
/*   ..$ :List of 1                                                                                                       */
/*   .. ..$ : num [1:367, 1:2] -80.4 -80.4 -80.3 -80.4 -80.4 ...                                                          */
/*   ..- attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"                                                            */
/*  - attr(*, "sf_column")= chr "geometry"                                                                                */
/*  - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA NA NA NA                                  */
/*   ..- attr(*, "names")= chr [1:7] "ZCTA5CE20" "AFFGEOID20" "GEOID20" "NAME20" ...                                      */
/*  - attr(*, "tigris")= chr "zcta"                                                                                       */
/* > print(zctas)                                                                                                         */
/* Simple feature collection with 33791 features and 7 fields                                                             */
/* Geometry type: MULTIPOLYGON                                                                                            */
/* Dimension:     XY                                                                                                      */
/* Bounding box:  xmin: -176.6967 ymin: -14.37374 xmax: 145.8304 ymax: 71.34122                                           */
/* Geodetic CRS:  NAD83                                                                                                   */
/* First 10 features:                                                                                                     */
/*    ZCTA5CE20     AFFGEOID20 GEOID20 NAME20 LSAD20   ALAND20 AWATER20                                                   */
/* 1      15301 860Z200US15301   15301  15301     Z5 315861121   709775                                                   */
/* 2      15658 860Z200US15658   15658  15658     Z5 238683518   759690                                                   */
/* 3      15601 860Z200US15601   15601  15601     Z5 208874774   337008                                                   */
/* 4      17720 860Z200US17720   17720  17720     Z5   8797202     2822                                                   */
/* 5      18843 860Z200US18843   18843  18843     Z5   3620019        0                                                   */
/* 6      30114 860Z200US30114   30114  30114     Z5 246536321 17044903                                                   */
/* 7      30281 860Z200US30281   30281  30281     Z5 179405961  2749692                                                   */
/* 8      31044 860Z200US31044   31044  31044     Z5 391881329   970277                                                   */
/* 9      31419 860Z200US31419   31419  31419     Z5 188809990 15139094                                                   */
/* 10     30137 860Z200US30137   30137  30137     Z5   8264947        0                                                   */
/*                          geometry                                                                                      */
/* 1  MULTIPOLYGON (((-80.3686 40...                                                                                      */
/* 2  MULTIPOLYGON (((-79.34323 4...                                                                                      */
/* 3  MULTIPOLYGON (((-79.66911 4...                                                                                      */
/* 4  MULTIPOLYGON (((-77.23026 4...                                                                                      */
/* 5  MULTIPOLYGON (((-75.90554 4...                                                                                      */
/* 6  MULTIPOLYGON (((-84.65791 3...                                                                                      */
/* 7  MULTIPOLYGON (((-84.29878 3...                                                                                      */
/* 8  MULTIPOLYGON (((-83.48153 3...                                                                                      */
/* 9  MULTIPOLYGON (((-81.38473 3...                                                                                      */
/* 10 MULTIPOLYGON (((-84.79026 3...                                                                                      */
/* > st_crs(have)                                                                                                         */
/* Coordinate Reference System: NA                                                                                        */
/* > points <- st_as_sf(have, coords = c("LONGITUDE", "LATITUDE"), crs = "NAD83")                                         */
/* > st_crs(points)                                                                                                       */
/* Coordinate Reference System:                                                                                           */
/*   User input: NAD83                                                                                                    */
/*   wkt:                                                                                                                 */
/* GEOGCRS["NAD83",                                                                                                       */
/*     DATUM["North American Datum 1983",                                                                                 */
/*         ELLIPSOID["GRS 1980",6378137,298.257222101,                                                                    */
/*             LENGTHUNIT["metre",1]]],                                                                                   */
/*     PRIMEM["Greenwich",0,                                                                                              */
/*         ANGLEUNIT["degree",0.0174532925199433]],                                                                       */
/*     CS[ellipsoidal,2],                                                                                                 */
/*         AXIS["geodetic latitude (Lat)",north,                                                                          */
/*             ORDER[1],                                                                                                  */
/*             ANGLEUNIT["degree",0.0174532925199433]],                                                                   */
/*         AXIS["geodetic longitude (Lon)",east,                                                                          */
/*             ORDER[2],                                                                                                  */
/*             ANGLEUNIT["degree",0.0174532925199433]],                                                                   */
/*     ID["EPSG",4269]]                                                                                                   */
/* > st_crs(zctas)                                                                                                        */
/* Coordinate Reference System:                                                                                           */
/*   User input: NAD83                                                                                                    */
/*   wkt:                                                                                                                 */
/* GEOGCRS["NAD83",                                                                                                       */
/*     DATUM["North American Datum 1983",                                                                                 */
/*         ELLIPSOID["GRS 1980",6378137,298.257222101,                                                                    */
/*             LENGTHUNIT["metre",1]]],                                                                                   */
/*     PRIMEM["Greenwich",0,                                                                                              */
/*         ANGLEUNIT["degree",0.0174532925199433]],                                                                       */
/*     CS[ellipsoidal,2],                                                                                                 */
/*         AXIS["latitude",north,                                                                                         */
/*             ORDER[1],                                                                                                  */
/*             ANGLEUNIT["degree",0.0174532925199433]],                                                                   */
/*         AXIS["longitude",east,                                                                                         */
/*             ORDER[2],                                                                                                  */
/*             ANGLEUNIT["degree",0.0174532925199433]],                                                                   */
/*     ID["EPSG",4269]]                                                                                                   */
/* > result <- st_join(points, zctas)                                                                                     */
/* > coords <- st_coordinates(result)                                                                                     */
/* > result$lon <- coords[,1]                                                                                             */
/* > result$lat <- coords[,2]                                                                                             */
/* > result <- st_drop_geometry(result)                                                                                   */
/* > result=data.frame(result[,c(1,8,9)])                                                                                 */
/* > result                                                                                                               */
/*    ZCTA5CE20        lon      lat                                                                                       */
/* 1      85750 -110.85959 32.30440                                                                                       */
/* 2      40291  -85.56570 38.09107                                                                                       */
/* 3      92677 -117.70471 33.55998                                                                                       */
/* 4      02767  -71.04260 41.92892                                                                                       */
/* 5      12180  -73.67012 42.73710                                                                                       */
/* 6      02744  -70.92210 41.61570                                                                                       */
/* 7      92503 -117.48399 33.87170                                                                                       */
/* 8      14217  -78.86896 42.96206                                                                                       */
/* 9      95123 -121.83024 37.24261                                                                                       */
/* 10     92843 -117.94868 33.75759                                                                                       */
/* 11     60615  -87.60896 41.80330                                                                                       */
/* 12     94536 -122.00228 37.54401                                                                                       */
/* > fn_tosas9x(                                                                                                          */
/* +       inp    = result                                                                                                */
/* +      ,outlib ="d:/sd1/"                                                                                              */
/* +      ,outdsn ="want"                                                                                                 */
/* +      )                                                                                                               */
/* >                                                                                                                      */
/* Stderr output:                                                                                                         */
/* To enable caching of data, set `options(tigris_use_cache = TRUE)                                                       */
/* in your R script or .Rprofile                                                                                          */
/* Warning message                                                                                                        */
/* package 'tigris' was built under R version 4.4.2                                                                       */
/* Linking to GEOS 3.12.2, GDAL 3.9.3, PROJ 9.4.1; sf_use_s2() is TRU                                                     */
/* Warning message                                                                                                        */
/* package 'sf' was built under R version 4.4.2                                                                           */
/* Stat/Transfer - Command Processor (c) 1986-2024 Circle Systems, Inc.                                                   */
/* www.stattransfer.com                                                                                                   */
/* Version 17.0.1756.0911 - 64 Bit Windows (10.0.19041)                                                                   */
/* Transferring to SAS Data File - Version Nine: d:/sd1/want.sas7bdat                                                     */
/*                                                                                                                        */
/* 12 cases were transferred(0.00 seconds)                                                                                */
/**************************************************************************************************************************/

/*  _              _       _           _
| || |    _ __ ___| | __ _| |_ ___  __| |  _ __ ___ _ __   ___  ___
| || |_  | `__/ _ \ |/ _` | __/ _ \/ _` | | `__/ _ \ `_ \ / _ \/ __|
|__   _| | | |  __/ | (_| | ||  __/ (_| | | | |  __/ |_) | (_) \__ \
   |_|   |_|  \___|_|\__,_|\__\___|\__,_| |_|  \___| .__/ \___/|___/
                                                   |_|
*/

REPO
----------------------------------------------------------------------------------------------------------------------------
https://github.com/rogerjdeangelis/utl_geocode_reverse_geocode
https://github.com/rogerjdeangelis/utl-dept-of-trans-address-database-to-sas-wps-tables-for-geocoding-and-reverse-geocoding
https://github.com/rogerjdeangelis/utl-free-unlimited-geocoding-reverse-geocoding-wps-aprox-I41-million-addresses-with-gps
https://github.com/rogerjdeangelis/utl-given-a-list-of-messy-addresses-geocode-and-reverse-geocode-using-us-address-database
https://github.com/rogerjdeangelis/utl-openaddress-database-to-sas-wps-tables-for-geocoding-and-reverse-geocoding
https://github.com/rogerjdeangelis/utl-standardize-address-suffix-using-usps-abreviations
https://github.com/rogerjdeangelis/utl-validate-email-address-and-domain-python
https://github.com/rogerjdeangelis/utl_US_address-standardization
https://github.com/rogerjdeangelis/utl_geocode_and_reverse_geocode_netherland_addresses_and_latitudes_longitudes

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

