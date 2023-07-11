#' Get account balances
#'
#' @return a list of balance names and values
#' @export
#' @importFrom magrittr %>%
#' @importFrom RCurl base64Decode base64Encode
#' @importFrom digest digest hmac
#' @importFrom httr content POST add_headers
get_available_balance <- function() {

  ## Define URL request before encryption
  url <- "https://api.kraken.com/0/private/Balance" # Define the base of the URL string
  method_path <- base::gsub("^.*?kraken.com", "", url) # Extract method path from URL string
  nonce <- base::as.character(base::as.numeric(base::Sys.time()) * 1000000) # Define the nonce based on the current time
  post <- base::paste0("nonce=", nonce) # Define the post data with the nonce and two factor code

  ## Encrypt the URL request
  secret <- RCurl::base64Decode(private_key, mode = "raw") # Decode private funds key
  sha256 <- digest::digest(object = base::paste0(nonce, post), algo = "sha256", serialize = F, raw = T) # Apply a cryptographical hash function to nonce and post data
  hmac <- digest::hmac(key = secret, object = c(base::charToRaw(method_path), sha256), algo = "sha512", raw = T) # Calculate hash-based message authentication code

  ## Post encrypted request
  out <- httr::content( url %>%
                          httr::POST(., body = post, httr::add_headers(c("API-Key" = public_key, "API-Sign" = RCurl::base64Encode(hmac)))))

  return(out) # Return output
}

#' Generate trades or ledger export report
#'
#' @param start_time Start time of the report
#' @param end_time End time of the report
#' @param report_type Type of the report, trades or ledgers
#' @param description Description of the report
#'
#' @return The generated report
#' @importFrom httr POST add_headers content
#' @importFrom RCurl base64Encode
generate_export_report <- function(start_time,end_time,report_type, description){
  ## Define URL request before encryption
  url <- "https://api.kraken.com/0/private/AddExport"
  method_path <- gsub("^.*?kraken.com", "", url)
  nonce <- as.character(as.numeric(Sys.time()) * 1000000)

  report <- report_type
  description <- description
  format <- "CSV"

  post_string <- paste0("nonce=", nonce, "&description=", description, "&report=", report, "&starttm=", start_time, "&endtm=", end_time)
  post <- list(nonce = nonce, description = description, report = report, starttm = start_time, endtm = end_time)

  hmac <- get_kraken_signature(private_key = private_key, nonce = nonce, post_string = post_string, method_path = method_path)

  out <- httr::content(
    httr::POST(
      url,
      body = post,
      httr::add_headers(
        "API-Key" = public_key,
        "API-Sign" = hmac
      ),
      encode = "form",
      httr::verbose()
    )
  )

  return(out)

}

#' Retrieve export data
#'
#' @param report_id The ID of the report to retrieve
#'
#' @return The retrieved export data
#' @importFrom httr POST add_headers content
#' @importFrom RCurl base64Encode
retrieve_export_data <- function(report_id){
  url = "https://api.kraken.com/0/private/RetrieveExport"
  method_path <- gsub("^.*?kraken.com", "", url)
  nonce <- as.character(as.numeric(Sys.time()) * 1000000)

  post_string <- paste0("nonce=", nonce, "&id=", report_id)
  post <- list(nonce = nonce, id = report_id)
  hmac <- get_kraken_signature(private_key = private_key, nonce = nonce, post_string = post_string, method_path = method_path)

  out <- httr::content(
    httr::POST(
      url,
      body = post,
      httr::add_headers(
        "API-Key" = public_key,
        "API-Sign" = hmac
      ),
      encode = "form",
      httr::verbose()
    )
  )

  extract_export_csv(out)
}

#' Unzip and extract CSV file
#'
#' @param bin_output Binary output data
#'
#' @return The extracted CSV data as a data frame
#' @importFrom utils unzip
#' @importFrom readr read_delim
extract_export_csv <- function(bin_output){
  temp_zip_file <- tempfile()
  writeBin(bin_output, temp_zip_file)

  extract_dir <- tempfile()
  utils::unzip(temp_zip_file, exdir = extract_dir)

  csv_file <- list.files(extract_dir, pattern = ".csv$", full.names = TRUE)

  df <- readr::read_delim(csv_file)

  unlink(temp_zip_file)
  unlink(extract_dir, recursive = TRUE)

  return(df)
}

#' Get API Signature
#'
#' @param private_key The private key
#' @param nonce The nonce
#' @param post_string The post string
#' @param method_path The method path
#'
#' @return The API signature
#' @importFrom RCurl base64Decode base64Encode
#' @importFrom digest digest hmac
get_kraken_signature <- function(private_key, nonce, post_string, method_path){
  ## Encrypt the URL request
  secret <- RCurl::base64Decode(private_key, mode = "raw") # Decode private funds key
  sha256 <- digest::digest(object = base::paste0(nonce, post_string), algo = "sha256", serialize = F, raw = T) # Apply a cryptographical hash function to nonce and post data
  hmac <- digest::hmac(key = secret, object = c(base::charToRaw(method_path), sha256), algo = "sha512", raw = T) # Calculate hash-based message authentication code
  return(RCurl::base64Encode(hmac))
}

#' Validate URLs
#'
#' @param url The URL to validate
#'
#' @return The validated URL or NA
#' @importFrom curl curl curl_fetch_memory
check_url <- function(url) {
  tryCatch(
    {
      con <- curl::curl(url)
      http_status <- curl::curl_fetch_memory(url)$status_code
      close(con)

      if (http_status == 200) { return(url) } else { return(NA) }
    },
    error = function(e) { return(NA) }
  )
}
