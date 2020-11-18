#' Get List of All Databases for a given Theme from TUIK
#'
#' @param theme Data Theme

#' @return A data tibble
#'
#' @examples
#' \dontrun{
#' statistical_databases(102)
#' }
#'
#' @export

statistical_databases <- function(theme) {
  sthemes <- check_theme_id(theme)

  request_url <- paste0(
    "https://data.tuik.gov.tr/Kategori/GetVeritabanlari?UstId=",
    theme,
    "&DilId=1&Page=1&Count=10000&Arsiv=true"
  )

  resp <- make_request(request_url)

  doc <- resp %>%
    xml2::read_html()

  db_name <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()

  db_url <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")

  sthemes <- statistical_themes() %>%
    dplyr::filter(.data$theme_id %in% theme)

  db <- tibble::tibble(db_name, db_url) %>%
    dplyr::bind_cols(sthemes) %>%
    dplyr::select(.data$theme_name, .data$theme_id, tidyselect::everything())
}
