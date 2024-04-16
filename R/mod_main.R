#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_main_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shiny::column(
        5,
        align = "center",
        shiny::h1("WOD Roulette"),
        shiny::h4("Get a random GoRuck 'sand' workout"),
        tags$br(),

        img(src = "www/logo.png", align = "center"),


        shiny::p(shiny::HTML(
          '<p>Spin the cylinder to get a random workout snagged from the
          <a href="https://www.goruck.com/blogs/news-stories/tagged/goruck-wod">GoRuck blog</a>.
          <br/>
          There are over 100 workouts in their blog archive to have "fun" with.
          </p>
          <p>Made by
  <a href="https://technistema.com/">Brad Lindblad</a>
        <a href="https://github.com/bradlindblad/randwod"><img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" height="23" /></a>
  </p>
  <p><em>Not affiliated with GoRuck in any form.</em></p>

  '
        )),


        tags$br(),
        tags$h4("Take your chances!"),
        tags$br(),
        shiny::actionButton(ns('spin'), label = "GET AFTER IT", width = "200px")
        # reactable::reactableOutput(ns("text_output"))
      ),
      column(1),
      column(5,
        align = "center",
        tags$br(),
        tags$br(),
        shiny::fluidRow(column(12,
          align = "left",
          shiny::htmlOutput(ns("printed_wo")),
          shiny::br(),
          shiny::br(),
          shiny::br()
          # selectInput(ns("expand_selection"), multiple = FALSE, choices = c("Jim", "James", "Jimothy"), selected = "Jim", label = "Expand convo", selectize = T),
        ))
      ),
      column(1)
    ),
  )
}

#' main Server Functions
#'
#' @noRd
mod_main_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$printed_wo <- shiny::renderUI({
      shiny::HTML(display_wod())
      # "cool"
    }) |>
      shiny::bindEvent(input$spin)

  })
}

## To be copied in the UI
# mod_main_ui("main_1")

## To be copied in the server
# mod_main_server("main_1")
