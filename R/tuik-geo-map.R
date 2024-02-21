#' Get Maps from TUIK
#'
#' @param level NUTS Level (2, 3, 4, or 9)
#'
#' @param dataframe Return data as data frame
#'
#' @return An sf object or tibble
#'
#' @import V8
#'
#' @examples
#' \dontrun{
#' geo_map(level = 2)
#' }
#'
#' @export
geo_map <- function(level = c(2, 3, 4, 9), dataframe = FALSE) {
  if (is.null(level)) {
    level <- 9
  } else {
    if (!(level %in% c(2, 3, 4, 9))) stop("There's no IBBS at this level!")
  }

  # query_url <- dplyr::case_when(
  #   level == 2 ~ "https://cip.tuik.gov.tr/assets/nuts2.min.js",
  #   level == 3 ~ "https://cip.tuik.gov.tr/assets/nuts3.min.js",
  #   level == 4 ~ "https://cip.tuik.gov.tr/assets/nuts4.min.js",
  #   level == 9 ~ "https://cip.tuik.gov.tr/assets/yerlesim_noktalari.min.js"
  # )
  #
  # ctx <- v8()
  # src <- ctx$source(query_url)
  # ctx$eval(src)
  #
  # dt_sf <- ctx$get(ctx$get(JS("Object.keys(global)"))[4]) %>%
  #   jsonlite::toJSON() %>%
  #   stringr::str_replace_all(
  #     '\\[\"FeatureCollection\"\\]',
  #     '\"FeatureCollection\"'
  #   ) %>%
  #   sf::read_sf()

  query_url <- dplyr::case_when(
    level == 2 ~ "https://cip.tuik.gov.tr/assets/geometri/nuts2.json",
    level == 3 ~ "https://cip.tuik.gov.tr/assets/geometri/nuts3.json",
    level == 4 ~ "https://cip.tuik.gov.tr/assets/geometri/nuts4.json",
    level == 9 ~ "https://cip.tuik.gov.tr/assets/geometri/yerlesim_noktalari.json"
  )

  tryCatch(
    expr = {
      dat <- jsonlite::fromJSON(query_url)
    },
    error = function(e) {
      stop(paste0("Mapping is not available at this NUTS level (level = ", level, ")!!!"))
    }
  )


  dt_sf <- dat %>%
    jsonlite::toJSON() %>%
    stringr::str_replace_all(
      '\\[\"FeatureCollection\"\\]',
      '\"FeatureCollection\"'
    ) %>%
    sf::read_sf()

  if (level != 9) {
    dt_sf <- dt_sf %>%
      dplyr::rename("code" = "duzeyKodu") %>%
      dplyr::mutate(code = as.character(code))
  }


  if (dataframe == FALSE) {
    return(dt_sf)
  } else {
    dt <- sf::st_drop_geometry(dt_sf)
    return(dt)
  }
}
