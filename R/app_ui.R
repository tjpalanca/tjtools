#' Application User Interface
#'
#' @param request Internal parameter for `{shiny}`. Do not remove!
#' @import shiny shinyWidgets
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    navbarPage(
      title = "TJTools",
      tabPanel(
        title = "Table Tools",
        mod_csv_to_gsheet_ui("csv_to_gsheet")
      )
    )
  )
}

#' External Resources for Shiny App
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'TJTools'
    )
  )
}

