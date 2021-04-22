test_that("CSV to GSheet module UI", {
    golem::expect_shinytaglist(mod_csv_to_gsheet_ui("id"))
})

testServer(mod_csv_to_gsheet_server, {
    withr::with_file(list("iris" = readr::write_csv(iris, "iris")), {
        session$setInputs(
            sheet_name = "Test Sheet",
            csv_files = tibble::tibble(
                datapath = "iris",
                name = "test_iris"
            ),
            google_email = "test@tjpalanca.com"
        )
        output$result
    })
})

