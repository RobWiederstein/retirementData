
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/RobWiederstein/retirement/workflows/R-CMD-check/badge.svg)](https://github.com/RobWiederstein/retirement/actions)
[![Travis build
status](https://travis-ci.com/RobWiederstein/retirement.svg?branch=main)](https://travis-ci.com/RobWiederstein/retirement)
[![Codecov test
coverage](https://codecov.io/gh/RobWiederstein/retirement/branch/main/graph/badge.svg)](https://codecov.io/gh/RobWiederstein/retirement?branch=main)
<!-- badges: end -->

<h4 align="center">
<a href="https://rob-wiederstein.shinyapps.io/retirement-dashboard/?_ga=2.138388592.1542637753.1630614255-2110524801.1630416115"><img src='man/figures/retirement-dashboard.png' align="center" height="400"/><br/></a>
<a href="https://rob-wiederstein.shinyapps.io/retirement-dashboard/?_ga=2.138388592.1542637753.1630614255-2110524801.1630416115">Retirement
Locator</a>
</h4>

# Introduction

The goal of the `retirementLoc` package was to consolidate some diverse
and relevant factors on where to locate for retirement. The data is
located in the `retirementLoc` package but displayed on a separate
dashboard
[here](https://rob-wiederstein.shinyapps.io/retirement-dashboard/?_ga=2.138388592.1542637753.1630614255-2110524801.1630416115).
Criteria were included in the following order:

-   the state name;
-   the county name;
-   a classification based on population density;
-   population (estimate) in 2020;
-   percent change of population since 2010;
-   partisan lean or percent of population voting Democrat in the 2020
    presidential race;
-   life expectancy;
-   average annual temperature;
-   broadband penetration as of 2017;
-   median value of owner occupied housing from 2009 adjusted for
    inflation and divided by average annual household income;
-   rate of violent crimes;
-   air quality and
-   access to a primary care physician.

## Installation

You can install the development and experimental version of
`retirementLoc` from its
[repository](https://github.com/RobWiederstein/retirementLoc) with:

``` r
# Or the development version from GitHub:
# install.packages("devtools")
install_github("RobWiederstein/retirementLoc")
```

## Load Data

Once the development package is installed, it can be loaded via:

``` r
library(retirementLoc)
```

## Common Questions

The data can provide some practical guidance as to candidate locations
by identifying high growth counties, reasonable housing costs, air
quality and life expectancy. For example, the code below might be used
to answer where housing costs are reasonable:

``` r
retirementLoc |>
        dplyr::arrange(years_to_payoff) |>
        dplyr::select(stname, ctyname, pop_2020, years_to_payoff) |>
        dplyr::slice(1:5)
#> # A tibble: 5 × 4
#>   stname       ctyname pop_2020 years_to_payoff
#>   <chr>        <chr>      <dbl>           <dbl>
#> 1 North Dakota Burke       2118             0.7
#> 2 Texas        Reeves     15949             0.7
#> 3 Texas        Foard       1135             0.8
#> 4 Texas        Ward       12097             0.8
#> 5 Texas        Winkler     7887             0.8
```

<!--You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this. You could also use GitHub Actions to re-render `README.Rmd` every time you push. An example workflow can be found here: <https://github.com/r-lib/actions/tree/master/examples>.


# Displaying Code Blocks

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN.
-->

## Code of Conduct

Please note that the retirementLoc project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
