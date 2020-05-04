azmpdata R package
================
Benoit Casault
02 May, 2020

<!-- README.md is generated from README.Rmd. Please edit that file -->

# *azmpdata*

<!-- badges: start -->

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

The *azmpdata* package provides three categories of data products:
physical, biological and chemical variables, which are summarized below.
Each data product is provided as a data frame (in the *azmpdata/data*
folder) or as a csv file (in the *azmpdata/data-raw* folder).

#### Physical Data Products

<!-- ``` r -->

<!-- library(tibble) -->

<!-- library(knitr) -->

<!-- ``` -->

#### Chemical Data Products

| Dataset                             | Description                                          |
| :---------------------------------- | :--------------------------------------------------- |
| nitrate\_inventory\_timeseries\_hl2 | Timeseries of nitrate inventory at Halifax-2 station |

#### Biological Data Products

| Dataset                                    | Description                                                |
| :----------------------------------------- | :--------------------------------------------------------- |
| chlorophyll\_inventory\_timeseries\_hl2    | Timeseries of chlorophyll inventory at Halifax-2 station   |
| chlorophyll\_inventory\_annual\_means\_hl2 | Annual means of chlorophyll inventory at Halifax-2 station |

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
help("chlorophyll_inventory_timeseries_hl2")
```

#### Keyword Search

The function *search\_azmpdata* allows to look up which datasets match a
certain keyword criterion. For example, the following command returns
all the datasets containing *chlorophyll* data:

``` r
library(azmpdata)
search_azmpdata("chlorophyll")
#> [1] "chlorophyll_inventory_annual_means_hl2"
#> [2] "chlorophyll_inventory_timeseries_hl2"
```
