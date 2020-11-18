#' Helper functions
#'
#' @keywords internal
# -------------------------------------------------------------------------- ###
# Helpers----
# -------------------------------------------------------------------------- ###
make_request <- function(url) {
  cli <- crul::HttpClient$new(url = url)
  res <- cli$post()
  res$raise_for_status()
  txt <- res$parse("UTF-8")
  return(txt)
}

check_theme_id <- function(theme) {
  sthemes <- statistical_themes()

  if (length(theme) != 1) {
    base::message(
      cat(crayon::blue("Valid themes and IDs are:"))
    )
    base::message(print(sthemes))

    stop(crayon::red("You can select only one theme!"))
  }



  if (!(theme %in% sthemes$theme_id)) {
    base::message(
      cat(crayon::blue("Valid themes and IDs are:"))
    )
    base::message(print(sthemes))

    stop(crayon::red("You should select a valid theme ID!"))
  }

  return(sthemes)
}
