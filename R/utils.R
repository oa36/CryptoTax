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
