#' Application Server Side Logic
#'
#' @param input,output,session Internal parameters for {shiny}.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
    callModule(mod_csv_to_gsheet_server, "csv_to_gsheet")
}
