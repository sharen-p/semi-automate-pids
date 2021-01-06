library(shiny)
library(shinydashboard)
library(shinyalert)
library(readxl)
library(xlsx)
library(shinyjs)
library(shinyWidgets)

ui <- dashboardPage(
  dashboardHeader(title = "MonetizeMore Project"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about", icon = icon("eye")),
      menuItem("Demo", tabName = "demo", icon = icon("eye"))
      
    )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "about",
              fluidRow(
                box("semi-automate the PID's for the Monetizemore Tools config."))
    ),
    tabItem(tabName = "demo",
            fluidPage(
              useShinyalert(),  # Set up shinyalert
              useShinyjs(),
              fluidRow(column(6,style = "background-color:yellow;",div(id='note_tem',tags$i(class="fa fa-info-circle"), 
                                                                       "Note: Please upload a file "))),
              fileInput('upload_file', 'Upload XLSX File',
                        accept=c('.xlsx'
                        )),
              uiOutput("input_ui"),
              actionButton("submit",'Submit')
            )
    )
  )
)
)

server <- function(input, output){
  output$input_ui <- renderUI({
    # upload file
    inFile<-input$upload_file
    if(is.null(inFile))
      return(NULL)
    #taking file into a data frame
    file_path <- read.xlsx(input$upload_file$datapath, 1,"Sheet3", startRow = 1, as.data.frame = TRUE)
    # figuring out numbers of col and row  
    numCol <- ncol(file_path)
    numRow <- nrow(file_path)
    # headers <- as.list(strsplit(paste(colnames(file_path), collapse = ','),",")[[1]])
    # running loops between row and col
    lapply(1:numRow, function(i){
      # browser()
      lapply(1:numCol, function(j){
        row = na.omit(file_path)
        a = as.list(strsplit(paste(colnames(file_path), collapse = ','),",")[[1]])
        print(a[j])
        # browser()
        textInput(paste0(a[j],j), label = a[j], value = row[i,j])
      })
    })
  })
  
  observeEvent(input$submit, {
    shinyalert("Success!", "Congratulations you have saved the details", type = "success")
  })
}

shinyApp(ui, server)
