#' Calculate Profit from Trades using FIFO Principle
#'
#' This function calculates the profit for each trade using the First-In-First-Out (FIFO) principle,
#' given a dataframe of trades. For each unique pair of assets, the function calculates the profit
#' for each "sell" trade based on the price difference with the earliest (first-in) "buy" trades.
#'
#' @param trades A dataframe of trades, which should have at least the following columns:
#' 'time' (the time of the trade), 'pair' (the trading pair), 'type' (the type of trade - buy or sell),
#' 'vol' (the volume of the trade), and 'price' (the price per unit).
#'
#' @return A dataframe summarizing the profit. Each row represents a profit calculated from a
#' "sell" trade, with columns for 'time' (the time of the trade), 'pair' (the trading pair),
#' and 'profit' (the profit from the trade).
#'
#' @export
calculate_profit_fifo <- function(trades) {
  # Initialize profit dataframe
  profit_df <- tibble::tibble(time=as.POSIXct(character()), pair=character(), profit = numeric())

  # Group trades by pair and arrange by time
  grouped_df <- trades %>% dplyr::group_by(pair) %>% dplyr::arrange(time)

  # Loop over each unique pair
  unique_pairs <- unique(grouped_df$pair)

  for(pair_group in unique_pairs){
    tx <- grouped_df %>% dplyr::filter(pair == pair_group)
    history <- tibble::tibble()
    for(i in 1:nrow(tx)){
      transactions <- tx[i,]

      if(transactions$type == "buy"){
        history <- dplyr::bind_rows(history, transactions)
      } else if(transactions$type == "sell") {
        sell_vol = transactions$vol

        while(sell_vol > 0 && nrow(history) > 0){
          buy_transactions <- history[1,]
          buy_vol <- buy_transactions$vol

          if(buy_vol <= sell_vol){
            profit <- buy_vol * (transactions$price - buy_transactions$price)
            profit_df <- profit_df %>%
              dplyr::add_row(time = transactions$time, pair = transactions$pair, profit = profit)
            sell_vol <- sell_vol - buy_vol
            history <- history[-1,]
          } else {
            profit <- sell_vol * (transactions$price - buy_transactions$price)
            profit_df <- profit_df %>%
              dplyr::add_row(time = transactions$time, pair = transactions$pair, profit = profit)
            history$vol[1] <- history$vol[1] - sell_vol
            sell_vol <- 0
          }
        }
      }
    }
  }

  return(profit_df)
}
