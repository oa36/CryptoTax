# CryptoTax

[![Build Status](https://travis-ci.org/oa36/CryptoTax.svg?branch=master)](https://travis-ci.org/oa36/CryptoTax)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/CryptoTax)](https://cran.r-project.org/package=CryptoTax)

CryptoTax is an R package designed to help you fetch your data seamlessly from [Kraken](https://www.kraken.com). Currently, the package empowers you to:

- **Access Available Balances:** Fetch up-to-date balance details from your Kraken account.
- **Create Export Reports:** Generate exportable reports of [trades or ledgers](https://support.kraken.com/hc/en-us/articles/115000302707-Differences-between-ledger-and-trades-history)
- **Load Export Reports:** Access and load your previously generated reports as dataframes, simplifying your data analysis process.

## Installation

You can install CryptoTax from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("oa36/CryptoTax")
```

## Usage

```r
library(CryptoTax)

## your kraken API keys
public_key <- Sys.getenv("YOUR-PUBLIC-KEY")
private_key <- Sys.getenv("YOUR-PRIVATE-KEY")

# get balances
get_available_balance()[["result"]] %>%
  available_balance %>%
  unlist() %>%
  stack() %>%
  dplyr::mutate(values = round(as.numeric(values), 2)) %>%
  dplyr::filter(values > 0)

# export and retrieve trades and ledgers
start_time <- as.integer(as.POSIXct("2020-01-01 00:00:00", tz = "UTC"))
end_time <- as.integer(as.POSIXct("2023-01-01 00:00:00", tz = "UTC"))

export_report_ledgers <- generate_export_report(start_time=start_time, end_time=end_time,report_type = "ledgers", description = "my_ledger")
export_report_trades <-  generate_export_report(start_time=start_time, end_time=end_time,report_type = "trades", description = "my_trades")

#get exported trades and ledger dataframes
trades_df <- retrieve_export_data(export_report_trades$result$id)
ledger_df <- retrieve_export_data(export_report_ledgers$result$id)
```

## Development

To contribute, fork this repository, make your changes, and submit a pull request.
