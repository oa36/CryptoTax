#' Transform Ledger to Trades Dataframe
#'
#' This function transforms a given ledger dataframe into a trades dataframe. It filters out non-trading
#' activities and identifies buy/sell trades to generate a summary of trades. The generated trades dataframe
#' is similar to the structure of a trades export from Kraken. The function is needed because kraken trades
#' export does not include trades made through the classic kraken app (non pro)
#'
#' @param ledger_df A dataframe representing the ledger data. This dataframe should have at least the
#' following columns: 'type', 'refid', 'time', 'asset', 'amount', and 'fee'.
#'
#' @return A dataframe summarizing the trades. Each row represents a trade, with columns for 'time'
#' (the time of the trade), 'pair', 'type' (the type of trade - buy or sell), 'cost'
#' (price * vol), 'vol' (the volume of the trade), 'price' (the EUR price per unit), and 'fee'
#'
#' @export
transform_ledger_to_trades <- function(ledger_df) {
  # Filter out non-trading activities
  ledger_trades <- ledger_df %>%
    dplyr::filter(!type %in% c("deposit", "withdrawal", "staking", "transfer"))

  # Identify buy/sell trades
  ledger_trades <- ledger_trades %>%
    dplyr::group_by(refid) %>%
    dplyr::mutate(trade_type = dplyr::if_else(any(asset == 'ZEUR' & amount < 0), 'buy', 'sell')) %>%
    dplyr::ungroup()

  # Generate trades summary
  trades <- ledger_trades %>%
    dplyr::group_by(refid) %>%
    dplyr::arrange(asset) %>%
    dplyr::reframe(
      time = dplyr::first(time),
      pair = paste0(asset, collapse = ""),
      type = dplyr::first(trade_type),
      cost = abs(sum(amount[asset == "ZEUR"], na.rm = TRUE)),
      vol = abs(sum(amount[asset != "ZEUR"], na.rm = TRUE)),
      price = cost/vol,
      fee = max(fee)
    ) %>%
    dplyr::ungroup()

  return(trades)
}
