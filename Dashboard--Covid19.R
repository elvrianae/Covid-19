#
# Covid19 Shiny Dashboard. 
# Written by : Elvriana Elvani
# Department of Business statistics, Matana University
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# A. PACKAGES ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(ggplot2)
library(plotly)
library(shiny)                                  
library(markdown)
library(dplyr)

# B. PREPARE YOUR DATABASE  ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#covid19 = read.csv('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv')   
 
#write.csv(covid19, "Covid19.csv")
 
covid    <- read.csv("Covid19.csv")
View(covid)

Covid19  <- select(covid,
                   Country    = location,
                   Region     = region,
                   Week       = week,
                   Confirmed  = total_cases,
                   Deaths     = total_deaths,
                   Population = population
                  )

# C. BUILD YOUR SHINY APP ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# C.1 User Interface (ui) ----
ui<-navbarPage("Dashboard",
               tabPanel("Covid19",titlePanel("Cases"), 
                        sidebarLayout(
                          sidebarPanel(DT::dataTableOutput("table1"),
                                       downloadButton("downloadData",
                                                      "Download Data Here",
                                                      href = "https://github.com/elvrianae/Covid-19/blob/master/Covid19.csv")),
                          mainPanel(tableOutput("table1`")))),
               
               tabPanel("Visualization",
                        plotlyOutput("plot")),
               
               tabPanel("Help", 
                        titlePanel("Please contact:"), 
                        helpText("Elvriana Elvani ~ Student of 
                                Department of Business Statistics, 
                                Matana University at elvrianae@gmail.com"),
                        sidebarLayout(
                          sidebarPanel(
                            downloadButton("downloadCode", 
                                           "Download Code Here", 
                                           href = "https://github.com/elvrianae/Covid-19/blob/master/Dashboard--Covid19.R")),
                          mainPanel(tableOutput("table"))))
)

# C.2 Server ----

server<-function(input, output, session) {
  
  output$table1 <- DT::renderDataTable({DT::datatable(Covid19)})
  
  output$plot <- renderPlotly(
    {ggplotly(ggplot(Covid19, aes(Population, Deaths, color = Region)) +
                geom_point(aes(size = Confirmed, frame = Week, ids = Country)) +
                scale_x_log10())%>% 
        animation_opts(1000,easing="elastic",redraw=FALSE)})
  
}

shinyApp(ui, server)      # This is execute your apps
