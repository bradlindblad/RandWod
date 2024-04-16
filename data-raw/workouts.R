## code to prepare `workouts` dataset goes here
library(readr)




raw_loc <- here::here('data-raw/workouts.txt')

workouts <- readr::read_delim(raw_loc, delim = "|", col_names = c("title", "wo", "url"))

workouts <- workouts |>
  dplyr::mutate(title = trimws(toupper(title)))

# workouts |>
#   purrr::pmap(display_wod)

usethis::use_data(workouts, overwrite = TRUE)
