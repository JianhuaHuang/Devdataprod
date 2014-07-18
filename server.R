library(googleVis)
library(shiny)
load('global.rda')

shinyServer(function(input, output, session) {
  
  ## reactive data
  data.CA <- reactive(subset(eval(parse(text = paste0('CA', input$year))), County%in%input$county))
  data.CHL <- reactive(subset(eval(parse(text = paste0('CHL', input$year))), ORISPL%in%data.CA()$ORISPL))  ##data.CHL is a function, need data.CHL() to get results  
  data.CHW <- reactive(eval(parse(text = paste0('CHW', input$year)))[,c('OP_DATE', 'OP_HOUR', paste0('CO2.', data.CA()$ORISPL))])
  data.E <- reactive(subset(eval(parse(text = paste0('E', input$year))), COUNTY%in%input$county))
  data.EL.temp <- reactive(reshape(data.E()[, 1:19], direction = 'long', 
                              varying = list(8:19), v.names= 'CO2_ton', 
                              timevar= 'Month', idvar = colnames(data.E())[1:7]))
  data.EL <- reactive(data.frame(Year_Mon = as.Date(paste(input$year, data.EL.temp()$Month, '01', sep = '-')), 
                                 PLANT_NAME = paste(data.EL.temp()$PLANT_NAME, data.EL.temp()$PLANT_CODE, sep = '_'),
                                 data.EL.temp()[,-1]))
  rownames(data.EL) <- NULL
  #data.EL
  
  data.EIA_CAMD <- reactive(subset(eval(parse(text = paste0('EIA_CAMD', input$year))), County%in%input$county))
  # add LatLong to data.EIA_CAMD, which is needed for GvisMap
  data.EIA_CAMD.LatLong <- reactive (cbind(data.EIA_CAMD(), LatLong = paste(data.EIA_CAMD()$Latitude, data.EIA_CAMD()$Longitude, sep = ':')))
  
  ## Overview panel
  output$overview <- renderPrint(cat('In', input$year,', there are totally', nrow(data.EIA_CAMD()), 'non-zero-emission powerplants in', 
                                     ifelse(length(input$county) == 1, 
                                                   input$county, 
                                                   paste(paste(input$county[1:(length(input$county)-1)], collapse = ', '), 
                                                         ', and', input$county[length(input$county)])
                                            ), 
                                     'County.',  
                                     sum(data.EIA_CAMD()$Source == 'CAMD'), 'of them are from CAMD dataset, ', 
                                     sum(data.EIA_CAMD()$Source == 'EIA'), 'powerplants are from EIA dataset.',
                                     'The total annual emission is', sum(data.EIA_CAMD()[,'CO2_ton']), 'tons of CO2.'))

  output$GvisMap.EIA_CAMD.LatLong <- renderGvis(gvisMap(data.EIA_CAMD.LatLong(), 'LatLong', c('Plant Name'),
                                                        options=list(showTip=TRUE, enableScrollWheel=TRUE,
                                                                     mapType='hybrid', useMapTypeControl=TRUE,
                                                                     width=800,height=400)))
  
  output$GvisTable.EIA_CAMD <- renderGvis(
    if(input$Display.EIA_CAMD) 
      gvisTable(data.EIA_CAMD(), 
                options = list(height = 100 + 200*min((nrow(data.EIA_CAMD())-1), 10)/9, width = 800)))
  
  
  ## CAMD Powerplants panel
  output$GvisTable.CA <- renderGvis(
    if(input$Display.CAMD.Annual) 
      gvisTable(data.CA(), options = list(height = 100 + 200*min((nrow(data.CA())-1), 10)/9, width = 700)))
  
  output$GvisAnn.CHL <- renderGvis(gvisAnnotatedTimeLine(
    data = data.CHL(), datevar = 'POSIX', numvar = 'value', idvar = 'ORISPL',
    options = list(width = 800, legendPosition = 'newRow')))
  
  
  ## EIA Powerplants panel
  output$GvisTable.E <-  renderGvis(
    if(input$Display.EIA) 
      gvisTable(data.E(), options = list(width = 1000)))
  
#   output$colnames.E <- renderUI(
#     if(input$Display.EIA)
#     selectInput(inputId='EIA.display.column',
#                 label = ('Select columns to display (use "ctrl" key for multiple selection)'),
#                 choices = colnames(data.E())[-3],  # exclude the PLANT_NAME, which is displayed by default
#                 selected = colnames(data.E())[c(1,4:7, 20:22)],
#                 multiple = T)
#     )
#   
  output$EL <- renderGvis(gvisTable(data.EL()[,c(7,6,1,3:5,8,9)], options = list (width = 900)))
  
  output$GvisMotion.EL <- renderGvis(gvisMotionChart(data.EL(), 
                                                     idvar = 'PLANT_NAME', timevar = 'Year_Mon', 
                                                     xvar = 'Month', yvar = 'CO2_ton', 
                                                     colorvar = 'COUNTY'))
  
  ## side Panel
  output$download.CA <- downloadHandler(
    filename= function() paste0('CAMD.Annual.',paste(input$county, collapse = '_'), input$year, '.csv'),
    content = function(file) write.csv(data.CA(), file, row.names = F)
  ) 
  
  output$download.CHW <- downloadHandler(
    filename= function() paste0('CAMD.Hourly.', paste(input$county, collapse = '_'), input$year, '.csv'),
    content = function(file) write.csv(data.CHW(), file, row.names = F)
  ) 
  
  output$download.E <- downloadHandler(
    filename= function() paste0('EIA.', paste(input$county, collapse = '_'), input$year, '.csv'),
    content = function(file) write.csv(data.E(), file, row.names = F)
  ) 
      
}
            )


#c('OP_DATE', 'OP_HOUR', paste0('CO2_MASS.', CA2002$ORISPL_CODE))