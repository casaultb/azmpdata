azmpdata R package
================
Benoit Casault, Emily Chisholm
24 November, 2020

<!-- README.md is generated from README.Rmd. Please edit that file -->

# *azmpdata*

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/casaultb/azmpdata.svg?branch=master)](https://travis-ci.org/casaultb/azmpdata)
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
# install.packages("devtools")
devtools::install_github("casaultb/azmpdata")
```

## Datasets

The *azmpdata* package provides three types of data products: physical,
chemical and biological variables, which are summarized below. Each data
product is organized into a data table by temporal and regional scale
and category.

To access a dataset in data frame format:

``` r
library(azmpdata)
#> 
#>  casaultb/azmpdata status:
#>  (Package ver: 0.2019.0.9000) Up to date
#>  (Data ver:2020-10-28) is up to date
data("Derived_Annual_Broadscale")
head(Derived_Annual_Broadscale)
#>   year     area_name density_gradient_0_50 temperature_at_sea_floor
#> 1 1948 Scotion Shelf              -0.00139                       NA
#> 2 1949 Scotion Shelf              -0.00968                       NA
#> 3 1950 Scotion Shelf              -0.01883                       NA
#> 4 1951 Scotion Shelf              -0.00092                       NA
#> 5 1952 Scotion Shelf               0.00155                       NA
#> 6 1953 Scotion Shelf              -0.00313                       NA
#>   cold_intermediate_layer_volume minimum_temperature_in_cold_intermediate_layer
#> 1                           <NA>                                           <NA>
#> 2                           <NA>                                           <NA>
#> 3                           <NA>                                           <NA>
#> 4                           <NA>                                           <NA>
#> 5                           <NA>                                           <NA>
#> 6                           <NA>                                           <NA>
```

To access a dataset in csv format:

``` r
system.file("extdata", "Derived_Annual_Broadscale.csv", package = "azmpdata")
#> [1] "C:/Users/Benoi/Documents/R/win-library/3.6/azmpdata/extdata/Derived_Annual_Broadscale.csv"
```

### Variable Organization

Each table contains multiple variables, which fall under the temporal
and regional scale in a particular category. The example shown above
includes derived variables at an annual scale for broad regions (eg.
Scotian Shelf or Gulf of Maine). Variables can be found via the search
function `lookup_variable()`, which allows a user to search by variable
name, keyword, scale or category. For more information see
`?lookup_variable`. This function uses the information in the lookup
table `extdata/lookup/variable_look_up.csv`

## Package Functionality

Although the main goal of *azmpdata* is to provide easy access to a
variety of data products, the package also supports a few basic
functions for which examples are shown below.

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

–NEEDS TO BE UPDATED- The function *plot\_azmpdata* is a wrapper that
allows to plot a given variable in a dataset. Plot format differs
according to the type of dataset (e.g. timeseries or annual means). For
example, the following command displays a plot of the *chl\_0\_100*
variable from the *chlorophyll\_inventory\_annual\_means\_hl2* dataset:
