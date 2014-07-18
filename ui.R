shinyUI(pageWithSidebar(
  headerPanel("CO2 Emission from Powerplants"),

  sidebarPanel(

    #use this to change the size of different panels, but I don't understand the meaning of each line well, keep in to-do list
    tags$head(
      tags$style(type="text/css", "select { width: 200px; }"),
      tags$style(type="text/css", "textarea { max-width: 285px; }"),
      tags$style(type="text/css", ".jslider { max-width: 400px; }"),
      tags$style(type='text/css', ".well { max-width: 330px; }"),
      tags$style(type='text/css', ".span4 { max-width: 330px; }")
    ),
    
    ## choose year
    h4('Select variables for dynamic Vis'),
    
    selectInput(inputId = 'year',
                label = 'Year',
                choices = c(2002, 2008, 2009),
                selected = 2002),
    br(),br(),
    
    selectInput(inputId = 'county',
                choices = c('Salt Lake', 'Los Angeles', 'Orange', 'San Bernardino', 'Ventura', 'Riverside'),
                label = ('County (use "ctrl" key for muntiple selection)'),
                selected = 'Salt Lake',
                multiple = T),
    
    h5('Download Selected Data'),
    
    downloadLink("download.CA", "CAMD Annual"), br(),
    downloadLink("download.CHW", "CAMD Hourly"), br(),
    downloadLink("download.E", "EIA Monthly"),
    br(), br(),br(),
    
#     conditionalPanel(condition = 'input.tabset1 == "Overview"', 
#                      HTML('<img style="visibility:hidden;width:0px;height:0px;" border=0 width=0 height=0 src="http://c.gigcount.com/wildfire/IMP/CXNID=2000002.0NXC/bT*xJmx*PTEzNzQzNTY*MzA4ODcmcHQ9MTM3NDM1NjQ2MjkwNyZwPTYzNTAzMiZkPSZnPTEmbz*zZjM4ZjA5OTczOTY*MzU*YmY*/MWVlZjEyMmZkNjU*MCZvZj*w.gif" />                <a href="http://www.ipligence.com/visitor_extended/79cdaf16d05059b322b5fcbde5d89d6b/month">
#                           <img src="http://www.ipligence.com/visitor-maps/m/small/1/month/79cdaf16d05059b322b5fcbde5d89d6b" alt="Visit http://www.ipligence.com" style="border:0;" /></a>')),
#     
    ## clustrMap by google
    conditionalPanel(condition = 'input.tabset1 == "About"', 
                     HTML('<a href="http://www2.clustrmaps.com/user/0de10da03"><img src="http://www2.clustrmaps.com/stats/maps-no_clusters/glimmer.rstudio.com-jianhua-hestia-thumb.jpg" alt="Locations of visitors to this page" />
                           </a>'))
    
    #HTML('<a href="http://ipligence.com"><img src="http://www.ipligence.com/freetools/iplocation/b1/" alt="geolocation database" /></a>'),
# 
#     conditionalPanel(condition = "input.tabset1 == 'EIA Powerplants'", uiOutput('colnames.E'))
    ),
  
  mainPanel (

    tabsetPanel(
      id = 'tabset1',
      
      tabPanel('About',
               p('This Shiny app is developed for the class of Developing Data Product.
                 This app shows the CO2 emission from powerplants in six counties in three years(2002, 2008, and 2009).
                 The CO2 emission datasets are from Clean Air Markest Data (CAMD) and Energy Information Administration (EIA).
                 The CAMD provides hourly CO2 emission data, and the EIA provides monthly emission data.
                 The total CO2 emission is calculated automatically based on the selected year and county, and the plots will be updated.
                 Here is some instruction for the app:
                 '),
               tags$ul(
                 tags$li("Select the year and county you want to check with from the side panel."), 
                 tags$li("Check the summary information in the tabpanel of 'Overview'. The summary information in 'Overview' will update automatically according to the year and county selected
                         You can change the selction to check the update."),
                 tags$li("Click on the checkbox to display data, and click on the column names to sort data"),
                 tags$li("check the hourly emission data in the tabpanel of 'CAMD Powerplants'. 
                         Scroll your mouse to zoom in and out"),
                 tags$li("Check the monthly emission data in the tabpanel of 'EIA Powerplants'. 
                         Check the animation and select one powerplant to track the monthly change"),
                 tags$li("Download the selected data from the side panel.")
                 ),
               tags$b('Enjoy the app')
               ),
      
      tabPanel('Overview', 
               textOutput('overview'), 
               htmlOutput('GvisMap.EIA_CAMD.LatLong'),
               br(),
               checkboxInput(inputId = 'Display.EIA_CAMD', "Display Data (click on column names to sort)", value = FALSE),           
               htmlOutput('GvisTable.EIA_CAMD')),
      
      tabPanel('CAMD Powerplants',

               h4('CAMD Hourly Data'),
               htmlOutput('GvisAnn.CHL'),
               h6("Note: choose the zoom level on the upper-left corner or scroll your mouse to zoom in/out. 
                  Drag the scrollbar or click the side arrows to Move"),
               br(), 
               h4('CAMD Annual Data'),
               checkboxInput(inputId = 'Display.CAMD.Annual', "Display Data (click on column names to sort)", value = FALSE),
               conditionalPanel(condition = "input.Display.CAMD.Annual == TRUE", htmlOutput('GvisTable.CA')), 
               br(), br() 
               ), 
      
      tabPanel('EIA Powerplants', 
               #htmlOutput('EL'),
               h4('EIA Monthly Data'),
               htmlOutput('GvisMotion.EL'),
               h6('Note: select powerplants or click on the points to track.'),
               br(),
               checkboxInput(inputId = 'Display.EIA', "Display Data (click on column names to sort)", value = FALSE),
               conditionalPanel(condition = "input.Display.EIA == TRUE", htmlOutput('GvisTable.E')), 
               br(), br()
      )
      )
    
    )
  )
        )
