# CryptoTax

[![Build Status](https://travis-ci.org/YourUsername/MyRPackage.svg?branch=master)](https://travis-ci.org/YourUsername/MyRPackage)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/MyRPackage)](https://cran.r-project.org/package=MyRPackage)
[![Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/MyRPackage)](https://cran.r-project.org/package=MyRPackage)
[![Coverage Status](https://img.shields.io/codecov/c/github/YourUsername/MyRPackage/master.svg)](https://codecov.io/github/YourUsername/MyRPackage?branch=master)

CryptoTax is an R package that helps you retrieve your data and calculate your profit/loss from Kraken.

## Installation

You can install CryptoTax from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("oa36/CryptoTax")
```

## Usage

```r
library(CryptoTax)

# Show example usage
```

## Development

To contribute, fork this repository, make your changes, and submit a pull request.

# CryptoTax

-   crypto taxs in germany are income taxes and considered as private assest

-   if hold for less than a year -\> you pay income tax --\> holding less than a year includes selling or swapping your crypto or spending it on goods

-   if you hold crypto for more than a year --\> its tax free

-   mining or staking rewards are also taxed --\> \>= 250€ yearly threshold

-   you can offset crypto losses against your profits; you can also carry forward losses to future financial years

-   taxes should be calculated based on First-in-First-Out principle

-   check income tax buckets here : <https://koinly.io/guides/crypto-tax-germany/>
