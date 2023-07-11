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

# EXPORT AND RETRIEVE trades and ledgers
start_time <- as.integer(as.POSIXct("2020-01-01 00:00:00", tz = "UTC"))
end_time <- as.integer(as.POSIXct("2023-01-01 00:00:00", tz = "UTC"))

#create an export reprot
export_report_ledgers <- generate_export_report(start_time=start_time, end_time=end_time,report_type = "ledgers", description = "my_ledger")
export_report_trades <-  generate_export_report(start_time=start_time, end_time=end_time,report_type = "trades", description = "my_trades")

#get trades and ledger dataframes
trades_df <- retrieve_export_data(export_report_trades$result$id)
ledger_df <- retrieve_export_data(export_report_ledgers$result$id)
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
