azmpdata R package
================
Benoit Casault, Emily Chisholm
20 February, 2026

<!-- README.md is generated from README.Rmd. Please edit that file -->

# *azmpdata*

<!-- badges: start -->

[![R-CMD-check](https://github.com/casaultb/azmpdata/actions/workflows/R-CMD-CHECK.yaml/badge.svg)](https://github.com/casaultb/azmpdata/actions/workflows/R-CMD-CHECK.yaml/badge.svg)

<!-- badges: end -->

The R package *azmpdata* provides a series of data products derived from
raw data collected as part of the Atlantic Zone Monitoring Program
([AZMP](https://www.dfo-mpo.gc.ca/science/data-donnees/azmp-pmza/index-eng.html)).
The data products provided in this package are used to generate the
different figures contained in the Research Documents produced annually
by Fisheries and Ocean Canada’s Maritimes region. The Research Documents
describe the physical, chemical and biological conditions observed in
Maritimes region since the inception of the AZMP program (see example
documents for the
[physical](http://www.dfo-mpo.gc.ca/csas-sccs/Publications/ResDocs-DocRech/2018/2018_016-eng.html)
conditions and for the [optical, chemical and
biological](http://www.dfo-mpo.gc.ca/csas-sccs/Publications/ResDocs-DocRech/2018/2018_017-eng.html)
conditions).

## Package Installation

The *azmpdata* R package can be installed from
[GitHub](https://github.com) with:

``` r
library(remotes)
remotes::install_github(repo = "casaultb/azmpdata", ref = "master", build_vignettes = TRUE)
```

## Datasets

The *azmpdata* package provides three types of data products: physical,
chemical and biological variables, which are summarized below. Each data
product is organized into a data table by temporal and regional scale
and category.

To access a dataset in data frame format:

``` r
library(azmpdata)
#> casaultb/azmpdata status:
#>  (Package ver: 0.2019.0.9100) Up to date
#>  (Data ver:2021-01-14 ) Up to date
#>  azmpdata:: Indexing all available monthly azmpdata...
data("Derived_Annual_Broadscale")
head(Derived_Annual_Broadscale)
#>   year              area density_gradient_0_50 sea_temperature_0 salinity_0
#> 1 1948 scotian_shelf_box               0.02715              6.45      31.23
#> 2 1949 scotian_shelf_box               0.01339              8.97      31.83
#> 3 1950 scotian_shelf_box               0.00587              8.15      31.92
#> 4 1951 scotian_shelf_box               0.02733              9.55      31.21
#> 5 1952 scotian_shelf_box               0.03159              8.91      31.02
#> 6 1953 scotian_shelf_box               0.02433              8.89      31.27
#>   temperature_at_sea_floor cold_intermediate_layer_volume
#> 1                       NA                             NA
#> 2                       NA                             NA
#> 3                       NA                             NA
#> 4                       NA                             NA
#> 5                       NA                             NA
#> 6                       NA                             NA
#>   minimum_temperature_in_cold_intermediate_layer north_atlantic_oscillation
#> 1                                             NA                         NA
#> 2                                             NA                         NA
#> 3                                             NA                         NA
#> 4                                             NA                         NA
#> 5                                             NA                         NA
#> 6                                             NA                         NA
#>   sea_surface_temperature_from_satellite
#> 1                                     NA
#> 2                                     NA
#> 3                                     NA
#> 4                                     NA
#> 5                                     NA
#> 6                                     NA
```

To access a dataset in csv format:

``` r
system.file("extdata/csv", "Derived_Annual_Broadscale.csv", package = "azmpdata")
#> [1] "C:/Users/ogradye/AppData/Local/Temp/1/RtmpWY0v01/temp_libpath305426945375/azmpdata/extdata/csv/Derived_Annual_Broadscale.csv"
```

### Variable Organization

Each table contains multiple variables, which fall under the temporal
and regional scale in a particular category. The example shown above
includes derived variables at an annual scale for broad regions (eg.
Scotian Shelf or Gulf of Maine). Variables can be found via the search
function `variable_lookup()`, which allows a user to search by variable
name or keyword. For more information see `?variable_lookup`. This
function searches through variable names and (optionally) help files
from each dataset including metadata and variable definitions.

## Package Functionality

Although the main goal of *azmpdata* is to provide easy access to a
variety of data products, the package also supports a few basic
functions for which examples are shown below.

#### Searching Data

A custom search function has been developed in order to allow users to
find specific data. The function `variable_lookup()` can be used to
search through variable names in all `azmpdata` dataframes. Using the
argument `search_help`, this function can also search through all the
help text for package data. A sample use of this search function may
look as below:

``` r
res <- variable_lookup(keywords = c('nitrate', 'phosphate'), search_help = TRUE)
#> Joining with `by = join_by(keyword, variable, dataframe)`

head(res)
#> # A tibble: 6 × 3
#>   keyword variable                  dataframe                   
#>   <chr>   <chr>                     <chr>                       
#> 1 nitrate integrated_nitrate_0_50   Derived_Annual_Sections     
#> 2 nitrate integrated_nitrate_0_50   Derived_Annual_Stations     
#> 3 nitrate integrated_nitrate_0_50   Derived_Occupations_Sections
#> 4 nitrate integrated_nitrate_0_50   Derived_Occupations_Stations
#> 5 nitrate integrated_nitrate_50_150 Derived_Annual_Sections     
#> 6 nitrate integrated_nitrate_50_150 Derived_Annual_Stations
```

#### Dataset Documentation

A detailed description of the whole package is available using the
following command:

``` r
library(azmpdata)
help("azmpdata")
```

In addition, each dataset is documented and the following command
returns a detailed description about a given dataset:

``` r
library(azmpdata)
help("Derived_Annual_Broadscale")
```

#### Plotting

Plotting `azmpdata` is covered in a detailed vignette
`plotting_azmpdata`.

## For developers

Data managers and developers may need to update data within the package.
For more details on this process, please see the vignette
`update_azmpdata`. The vignette `style_guide` also provides more details
on the formatting of new data.
