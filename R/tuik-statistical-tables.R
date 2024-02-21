#' Get List of All Statistical Tables for a given Theme from TUIK
#'
#' @param theme Data Theme

#' @return A data tibble
#'
#' @examples
#' \dontrun{
#' statistical_tables(102)
#' }
#'
#' @export
statistical_tables <- function(theme) {
  sthemes <- check_theme_id(theme)

  request_url <- paste0(
    "https://data.tuik.gov.tr/Kategori/GetIstatistikselTablolar?UstId=",
    theme,
    "&DilId=1&Page=1&Count=10000&Arsiv=true"
  )

  resp <- make_request(request_url)

  doc <- resp %>%
    xml2::read_html()

  table_names <- doc %>%
    rvest::html_table() %>%
    `[[`(1) %>%
    dplyr::select(-X3, -X4) %>%
    dplyr::filter(X2 != "") %>%
    dplyr::mutate(X1 = stringr::str_remove_all(X1, "\\u0130statistiksel TablolarYeni\r\n[ ]+")) %>%
    dplyr::mutate(X1 = stringr::str_remove_all(X1, "\\u0130statistiksel Tablolar\r\n[ ]+")) |>
    dplyr::mutate(X1 = stringr::str_remove_all(X1, "\\u0130statistiksel Tablolar\n[ ]+"))

  table_urls <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")

  table_meta <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("title")

  table_urls <- tibble::tibble(table_urls, table_meta) %>%
    dplyr::filter(table_meta != "Tablo Metaverisi") %>%
    dplyr::select(-table_meta) %>%
    dplyr::mutate(table_urls = paste0("http://data.tuik.gov.tr", table_urls))

  sthemes <- sthemes %>%
    dplyr::filter(theme_id %in% theme)

  # Quick fix for locale
  mylocale <- dplyr::if_else(Sys.info()["sysname"] == "Windows", "Turkish_Turkey.utf8", "tr_TR")


  st <- tibble::tibble(table_names, table_urls) %>%
    purrr::set_names("data_name", "data_date", "datafile_url") %>%
    dplyr::mutate(data_date = lubridate::dmy(data_date, locale = mylocale)) %>%
    dplyr::bind_cols(sthemes) %>%
    dplyr::select(theme_name, theme_id, tidyselect::everything())


  return(st)
}
