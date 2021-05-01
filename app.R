library(shiny)
library(shinybusy)

#' Return Chrome CLI arguments
#'
#' This is a helper function which returns arguments to be passed to Chrome.
#' This function tests whether the code is running on shinyapps and returns the
#' appropriate Chrome extra arguments.
#'
#' @param default_args Arguments to be used in any circumstances.
#'
#' @return A character vector with CLI arguments to be passed to Chrome.
chrome_extra_args <- function(default_args = c("--disable-gpu")) {
  args <- default_args
  # Test whether we are in a shinyapps container
  if (identical(Sys.getenv("R_CONFIG_ACTIVE"), "shinyapps")) {
    args <- c(args,
      "--no-sandbox", # required because we are in a container
      "--disable-dev-shm-usage") # in case of low available memory
  }
  args
}

#' Get the path of a pagedown template
#'
#' @param template Name of a pagedown template
#'
#' @return A file path.
template_file <- function(template) {
  system.file(
    "rmarkdown", "templates", template, "skeleton", "skeleton.Rmd",
    package = "pagedown",
    mustWork = TRUE
  )
}

ui <- fluidPage(
  selectInput(
    "template", "Choose a template:",
    choices = c(
      "html-letter",
      "html-paged",
      "html-resume",
      "jss-paged",
      "thesis-paged"
    )
  ),
  actionButton("buildPDF", "Build PDF document"),
  uiOutput("downloadBtn"),
  div(
    "Source code available at",
    a(
      "https://github.com/RLesur/chrome_print_shiny",
      href = "https://github.com/RLesur/chrome_print_shiny"
    )
  )
)

server <- function(input, output) {
  observeEvent(input$buildPDF, {
    output$downloadBtn <- renderUI({
      # add a spinner which blocks the UI
      show_modal_spinner()
      # launch the PDF file generation
      pagedown::chrome_print(
        template_file(input$template),
        output = tempfile(fileext = ".pdf"),
        extra_args = chrome_extra_args(),
        verbose = 1,
        async = TRUE # returns a promise
      )$then(
        onFulfilled = function(value) {
          showNotification(
            paste("PDF file succesfully generated"),
            type = "message"
          )
          output$downloadPDF <- downloadHandler(
            filename = function() {
              paste0(input$template, ".pdf")
            },
            content = function(file) {
              file.copy(value, file)
            },
            contentType = "application/pdf"
          )
          # return a download button
          downloadButton("downloadPDF", paste("Download", input$template))
        },
        onRejected = function(error) {
          showNotification(
            error$message,
            duration = NULL,
            type = "error"
          )
          HTML("")
        }
      )$finally(remove_modal_spinner)
    })
  })

  observeEvent(input$template, {
    output$downloadBtn <- renderUI(HTML(""))
  })
}

shinyApp(ui = ui, server = server)
