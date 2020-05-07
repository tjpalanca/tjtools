#' CSV to Google Sheet UI Function
#'
#' @description
#' Tool that allows upload of CSV files and sending to a google sheet.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @noRd
#' @importFrom shiny NS tagList
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
#' @importFrom googledrive drive_get drive_mv drive_auth drive_share
#' @importFrom googlesheets4 gs4_auth gs4_create
mod_csv_to_gsheet_server <- function(input, output, session) {
  ns <- session$ns

  combined_sheet <-
    eventReactive(
      input$csv_files, {
        # Authenticate credentials
        service_account.json <-
          rawToChar(gargle:::secret_read("tjtools", "service-account.json"))
        gs4_auth  (path = service_account.json)
        drive_auth(path = service_account.json)

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
          drive_get()

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
