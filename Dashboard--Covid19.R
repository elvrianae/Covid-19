#
# Covid19 Shiny Dashboard. 
# Written by : Bakti Siregar, M.Si
# Department of Business statistics, Matana University (Tangerang)
# Notes: Please don't share this code anywhere (just for my students)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# A. PACKAGES----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(ggplot2)
library(plotly)
library(shiny)                                          # This packages use to create shiny web apps
library(markdown)
library(openxlsx)

# B. PREPARE YOUR DATABASE  ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Covid_19 <- read.xlsx("Covid_19_.xlsx")

# C. BUILD YOUR SHINY APP ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# C.1 User Interface (ui) ----
ui<-navbarPage("Dashboard",
               tabPanel("Covid19",titlePanel("Cases"), DT::dataTableOutput("table1")),
               
               tabPanel("Visualization",plotlyOutput("plot")),
               
               tabPanel("Help", titlePanel("Please contact:"), helpText("Bakti Siregar, M.Sc ~ Lecturer of 
               Department of Business Statistics, Matana University (Tangerang) at siregarbakti@gmail.com"))
)

# C.2 Server ----
server<-function(input, output, session) {
    output$table1 <- DT::renderDataTable({DT::datatable(Covid19)})
    output$plot <- renderPlotly(
        {ggplotly(ggplot(Covid19, aes(Recovery, Dead, color = Region)) +
                      geom_point(aes(size = Positive, frame = Week, ids = Country)) +
                      scale_x_log10())%>% 
                animation_opts(1000,easing="elastic",redraw=FALSE)})
    
}

shinyApp(ui, server)      # This is execute your apps






