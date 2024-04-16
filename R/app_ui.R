#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic

    tags$head(
      tags$script(src = "https://platform.twitter.com/widgets.js", charset = "utf-8"),
      tags$link(href = "https://fonts.googleapis.com/css?family=Tilt+Neon", rel = "stylesheet"),
      tags$style(HTML("
      * {
        font-family: Tilt Neon;
        font-size: 100%;
      }
      #sidebar {
         background-color: #fff;
         border: 0px;
      }
      .rt-th {
        display: none;
      }
      .rt-noData {
        display: none;
      }
      .rt-pagination-nav {
        float: left;
        width: 100%;
      }
    "))
    ),
    fluidPage(
      waiter::use_waiter(),
      waiter::autoWaiter(html = waiter::spin_3(), color = waiter::transparent(0.6)),
      mod_main_ui("main_1")

    )
  )
}


#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "WOD Roulette"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
