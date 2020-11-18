#' Get Geographic Data from TUIK
#'
#' @param level NUTS Level (2, 3, or 4)
#'
#' @param variable Data Series Name
#'
#' @return A data tibble
#'
#' @examples
#' \dontrun{
#' geo_data(level = 2)
#' }
#'
#' @export
geo_data <- function(level = NULL, variable = NULL) {
  if (is.null(level)) {
    level <- 2
  } else {
    if (!(level %in% c(2, 3, 4))) stop("There's no IBBS at this level!")
  }


  doc <- xml2::read_html("https://cip.tuik.gov.tr/assets/menuPopulate.min.js?v=1.3") %>%
    rvest::html_text()

  variable_no <- doc %>%
    stringr::str_extract_all('gostergeNo:"[:alnum:]+-[:alnum:]+-[:alnum:]+') %>%
    purrr::map(~ stringr::str_remove_all(.x, 'gostergeNo:\"')) %>%
    unlist()

  variable_name <- doc %>%
    stringr::str_split("duzeyler") %>%
    purrr::map(~ stringr::str_extract_all(.x, '(?<=gostergeAdi:").*(?=")')) %>%
    unlist()

  variable_dt <- tibble::tibble(variable_name, variable_no)

  if (is.null(variable)) {
    return(variable_dt)
  }

  query_url <- dplyr::case_when(
    level == 2 ~ paste0("https://cip.tuik.gov.tr/veri/D2-", variable, ".js?v=1.2"),
    level == 3 ~ paste0("https://cip.tuik.gov.tr/veri/D3-", variable, ".js?v=1.2"),
    level == 4 ~ paste0("https://cip.tuik.gov.tr/veri/D4-", variable, ".js?v=1.2")
  )

  tryCatch(
    expr = {
      dat <- jsonlite::fromJSON(query_url)
    },
    error = function(e) {
      stop(paste0("This data (", variable, ") is not available at this NUTS level (level = ", level, ")!!!"))
    }
  )

  vals_name <- unlist(variable_dt[variable_dt$variable_no == variable, "variable_name"])

  if (nchar(dat$sureler[1]) == 6) {
    dates <- paste(stringr::str_sub(dat$sureler, 1, 4), stringr::str_sub(dat$sureler, 5, 6), sep = "-")
  } else {
    dates <- dat$sureler
  }

  res <- dat$veriler %>%
    tidyr::unnest_wider(.data$veri) %>%
    purrr::set_names(c("code", dates)) %>%
    tidyr::pivot_longer(-.data$code,
      names_to = "date",
      values_to = vals_name
    ) %>%
    janitor::clean_names()

  return(res)
}
