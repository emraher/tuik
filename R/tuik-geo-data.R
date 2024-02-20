#' Get Geographic Data from TUIK
#'
#' @param variable_level NUTS Level (2, 3, or 4)
#'
#' @param variable_no Data Series Number
#'
#' @param variable_source Data Series Source ("medas" or "ilGostergeleri")
#'
#' @param variable_period Data Series Period ("yillik" or "aylik")
#'
#' @param variable_recordnum Data Series Record Number (3, 5, or 24)
#'
#' @return A data tibble
#'
#' @examples
#' \dontrun{
#' geo_data(level = 2)
#' }
#'
#' @export
geo_data <- function(variable_no = NULL,
                     variable_level = NULL,
                     variable_source = NULL,
                     variable_period = NULL,
                     variable_recnum = NULL) {

  if (is.null(variable_level)) {
    variable_level <- 2
  } else {
    if (!(variable_level %in% c(2, 3, 4))) stop("There's no IBBS at this level!")
  }


  doc <- xml2::read_html("https://cip.tuik.gov.tr/assets/sideMenu.json?v=2.000") %>%
    rvest::html_text() |>
    rjson::fromJSON()




  var_num <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~purrr::pluck(.x, "gostergeNo")) |>
    unlist()

  var_name <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~purrr::pluck(.x, "gostergeAdi")) |>
    unlist()

  var_levels <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~purrr::pluck(.x, "duzeyler"))

  var_period <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~purrr::pluck(.x, "period")) |>
    unlist()

  var_source <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~purrr::pluck(.x, "kaynak")) |>
    unlist()

  var_recordnum <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~purrr::pluck(.x, "kayitSayisi")) |>
    unlist()


  # variable_no <- doc %>%
  #   stringr::str_extract_all('gostergeNo:"[:alnum:]+-[:alnum:]+-[:alnum:]+') %>%
  #   purrr::map(~ stringr::str_remove_all(.x, 'gostergeNo:\"')) %>%
  #   unlist()
  #
  # variable_name <- doc %>%
  #   stringr::str_split("duzeyler") %>%
  #   purrr::map(~ stringr::str_extract_all(.x, '(?<=gostergeAdi:").*(?=")')) %>%
  #   unlist()

  variable_dt <- tibble::tibble(var_name, var_num, var_levels,
                                var_period, var_source, var_recordnum)

  if (is.null(variable_no)) {
    return(variable_dt)
  } else {
    query_url <- paste0("https://cip.tuik.gov.tr/Home/GetMapData?kaynak=", variable_source,
                        "&duzey=", variable_level,
                        "&gostergeNo=", variable_no,
                        "&kayitSayisi=", variable_recnum,
                        "&period=", variable_period)

    # query_url <- dplyr::case_when(
    #   level == 2 ~ paste0("https://cip.tuik.gov.tr/Home/GetMapData?kaynak=medas&duzey=2&gostergeNo=", variable, "&kayitSayisi=5&period=yillik"),
    #   level == 3 ~ paste0("https://cip.tuik.gov.tr/Home/GetMapData?kaynak=medas&duzey=3&gostergeNo=", variable, "&kayitSayisi=5&period=yillik"),
    #   level == 4 ~ paste0("https://cip.tuik.gov.tr/Home/GetMapData?kaynak=medas&duzey=4&gostergeNo=", variable, "&kayitSayisi=5&period=yillik")
    # )

    tryCatch(
      expr = {
        dat <- jsonlite::fromJSON(query_url)
      },
      error = function(e) {
        stop(paste0("This data (", variable_no, ") is not available at this NUTS level (level = ", variable_level, ")!!!"))
      }
    )

    vals_name <- unlist(variable_dt[variable_dt$var_num == variable_no, "var_name"])

    if (nchar(dat$tarihler[1]) == 6) {
      dates <- paste(stringr::str_sub(dat$tarihler, 1, 4), stringr::str_sub(dat$tarihler, 5, 6), sep = "-")
    } else {
      dates <- dat$tarihler
    }

    res <- dat$veriler %>%
      tidyr::unnest_wider(data = ., col = veri, names_sep = ", ") %>%
      purrr::set_names(c("code", dates)) %>%
      tidyr::pivot_longer(-code,
                          names_to = "date",
                          values_to = vals_name
      ) %>%
      janitor::clean_names() %>%
      dplyr::mutate(code = as.character(code))

    return(res)

  }

  }
