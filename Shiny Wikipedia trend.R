library(shiny)
library(ggplot2)
library(dplyr)
library(wikipediatrend)

ui <- fluidPage(
  fluidRow(sidebarPanel(textInput("page_input", "Wikipedia page name"),
                        sliderInput("from", "From", min = as.Date("2007-12-10",,"%Y-%m-%d"), max=Sys.Date(), value = as.Date("2007-12-10","%Y-%m-%d"))),
           mainPanel(h2("Number of views of Wikipedia page"),
                     plotOutput("plot_output")))
)

server <- function(input, output){
  pg <- reactive({wp_trend(page = input$page_input, from = input$from)})
  
  output$plot_output <- renderPlot({
    ggplot(data = pg(),aes(x=pg()$date,y=pg()$views))+
      geom_line(col="steelblue")+ 
      labs(title = paste("Views of", input$page_input, "Wikipedia page"))+
      theme(legend.position="none")+
      xlab("Date")+
      ylab("Number of views")+
      theme_bw() 
  })
}

shinyApp(ui, server)