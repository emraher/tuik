#' Get Statistical Themes and URLS from TUIK
#'
#' @return A tibble
#'
#' @examples
#' \dontrun{
#' statistical_themes()
#' }
#'
#' @export
statistical_themes <- function() {
  doc <- xml2::read_html("https://data.tuik.gov.tr/") %>%
    rvest::html_nodes("div.text-center") %>%
    rvest::html_nodes("a")

  theme_name <- doc %>%
    rvest::html_text() %>%
    stringr::str_trim()

  theme_id <- doc %>%
    rvest::html_attr("href") %>%
    stringr::str_extract_all("[:digit:]+") %>%
    unlist()

  statistical_themes <- tibble::tibble(theme_name, theme_id)

  return(statistical_themes)
}
