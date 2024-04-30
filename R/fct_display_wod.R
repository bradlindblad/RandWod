#' display_wod
#'
#' @description A fct function
#'
#' @return Printed text from random wod
#'
#' @noRd
display_wod <- function(...) {
  # wo <- dplyr::tibble(...)
  wo <- workouts |>
  dplyr::sample_n(size = 1)


  # 1. title
  a <- wo |>
    dplyr::pull(title) |>
    trimws() |>
    shiny::h3()


  # 2. WO
  b <- wo |>
    dplyr::pull(wo) |>
    trimws()
# b
  b <- gsub("\\\\n", "<br/>", b)


  # 3. Youtube link
  c <- wo|>
    dplyr::pull(url) |>
    trimws()

  c <- paste0('<a href="', c, '" target = "_blank">Youtube Instructions</a>')

  paste(
    a, "<br/>",  b, "<br/>", "<br/>",  c, "</br><em>Screenshot this workout to bring with you</em>"
  )


}

# display_wod()
