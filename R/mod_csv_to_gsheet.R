#' CSV to Google Sheet UI Function
#'
#' @description
#' Tool that allows upload of CSV files and sending to a google sheet.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @noRd
#' @importFrom shiny NS tagList
#' @import googledrive
mod_csv_to_gsheet_ui <- function(id){
  ns <- NS(id)
  tagList(
    panel(
      heading = "CSV to Google Sheet",
      p(
        "This tool allows you to send different CSVs to a Google Sheet ",
        "as separate sheets. Warning: This tool gives me access to the ",
        "contents of your files. If you do not know or trust me, then ",
        "do not use this feature! "
      ),
      fluidRow(
        column(
          width = 6,
          textInput(
            inputId = ns("sheet_name"),
            label   = "Sheet Name",
            value   = "CSV to Google Sheet"
          ),
          textInput(
            inputId = ns("google_email"),
            label   = "Google Email",
            value   = "troy.palanca@gmail.com"
          ),
          fileInput(
            inputId  = ns("csv_files"),
            label    = "Upload CSV files",
            multiple = TRUE,
            accept   = "text/csv"
          )
        ),
        column(
          width = 6,
          uiOutput(
            outputId = ns("result")
          )
        )
      )
    )
  )
}

#' CSV to Google Sheet Server Function
#'
#' @noRd
#' @importFrom setter set_names
#' @importFrom magrittr `%>%`
#' @importFrom purrr map
mod_csv_to_gsheet_server <- function(input, output, session) {
  ns <- session$ns

  combined_sheet <-
    eventReactive(
      input$csv_files, {
        # Authenticate credentials
        gs4_auth(email = "troy.palanca@gmail.com")
        drive_auth(email = "troy.palanca@gmail.com")

        # Create the combined sheet
        combined_sheet <-
          gs4_create(
            name = input$sheet_name,
            sheets = map(
              input$csv_files$datapath,
              readr::read_csv
            ) %>%
              set_names(input$csv_files$name)
          ) %>%
          drive_get() %>%
          drive_mv(path = as_id("1msj0de5AKSLhFvXirLaf2Kr4wb-5MzrO"))

        # Return the combined sheet
        combined_sheet
      }
    )

  output$result <- renderUI({
    req(combined_sheet())

    # Grant write access to the combined sheet
    drive_share(
      file = combined_sheet(),
      role = "writer",
      type = "user",
      emailAddress = input$google_email
    )

    # Return the result in the browser
    div(
      class = "alert alert-success", role = "alert",
      "Success! You may access the sheet ",
      tags$a(
        href = combined_sheet()$drive_resource[[1]]$webViewLink,
        target = "_blank",
        "here."
      )
    )
  })
}
