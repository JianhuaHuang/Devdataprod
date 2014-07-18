# library(googleVis)
# library(shiny)
# library(parallel)
# 
# fl <- Sys.glob('*Long.200*.csv')
# dt <- mclapply(fl, FUN= function(x) read.csv(x, colClass = c('POSIX' = 'POSIXct')), mc.cores=3)
# CHL2002 <- dt[[1]]
# CHL2008 <- dt[[2]]
# CHL2009 <- dt[[3]]
# 
# CA2002 <- read.csv('CAMD.Annual.2002.csv')
# CA2008 <- read.csv('CAMD.Annual.2008.csv')
# CA2009 <- read.csv('CAMD.Annual.2009.csv')
# 
# E2002 <- read.csv('EIA.Monthly.2002.csv')
# E2008 <- read.csv('EIA.Monthly.2008.csv')
# E2009 <- read.csv('EIA.Monthly.2009.csv')
# # name.duplicated <- E2002$PLANT_NAME[duplicated(E2002$PLANT_NAME)]
# # E2002[E2002$PLANT_NAME%in%name.duplicated, ]$PLANT_NAME <- 
# #   as.factor(paste(E2002[E2002$PLANT_NAME%in%name.duplicated, 'PLANT_NAME'], E2002[E2002$PLANT_NAME%in%name.duplicated, 'PLANT_CODE'], sep = '.'))
# # E2002[,1:6]
# 
# 
# 
# colnames(CA2002) = colnames(CA2008) = colnames(CA2009) = c('State', 'County', 'ORISPL', 'Plant', 'Year', 'Months', 'Lat', 'Long', 'CO2')
# 
# CHW2002 <- read.csv('CAMD.Hourly.Wide.2002.csv')
# CHW2008 <- read.csv('CAMD.Hourly.Wide.2008.csv')
# CHW2009 <- read.csv('CAMD.Hourly.Wide.2009.csv')
# 
# ## genrate EIA_CAMD200*
# EIA <- data.frame(Year = 2002, Source = 'EIA', E2002[, c(7,6,1,3:5, 20)])
# CAMD <- data.frame(Year = 2002, Source = 'CAMD',CA2002[, -(5:6)])
# colnames(CAMD)=colnames(EIA) = c('Year', 'Source', 'State',  'County', 'Plant Code', 'Plant Name', 'Latitude', 'Longitude', 'CO2_ton')
# EIA_CAMD2002 <- rbind(CAMD, EIA)
# EIA_CAMD2002 <- EIA_CAMD2002[!is.na(EIA_CAMD2002[,'CO2_ton']) & EIA_CAMD2002[,'CO2_ton'] > 0, ]
# EIA_CAMD2002 <- EIA_CAMD2002[!duplicated(EIA_CAMD2002[, 'Plant Code']), ]
# EIA_CAMD2002[,7:9] <- round(EIA_CAMD2002[,7:9], digit = 3)
# 
# EIA <- data.frame(Year = 2008, Source = 'EIA', E2008[, c(7,6,1,3:5, 20)])
# CAMD <- data.frame(Year = 2008, Source = 'CAMD',CA2008[, -(5:6)])
# colnames(CAMD)=colnames(EIA) = c('Year', 'Source', 'State',  'County', 'Plant Code', 'Plant Name', 'Latitude', 'Longitude', 'CO2_ton')
# EIA_CAMD2008 <- rbind(CAMD, EIA)
# EIA_CAMD2008 <- EIA_CAMD2008[!is.na(EIA_CAMD2008[,'CO2_ton']) & EIA_CAMD2008[,'CO2_ton'] > 0, ]
# EIA_CAMD2008 <- EIA_CAMD2008[!duplicated(EIA_CAMD2008[, 'Plant Code']), ]
# EIA_CAMD2008[,7:9] <- round(EIA_CAMD2008[,7:9], digit = 3)
# 
# EIA <- data.frame(Year = 2009, Source = 'EIA', E2009[, c(7,6,1,3:5, 20)])
# CAMD <- data.frame(Year = 2009, Source = 'CAMD', CA2009[, -(5:6)])
# colnames(CAMD)=colnames(EIA) = c('Year', 'Source', 'State',  'County', 'Plant Code', 'Plant Name', 'Latitude', 'Longitude', 'CO2_ton')
# EIA_CAMD2009 <- rbind(CAMD, EIA)
# EIA_CAMD2009 <- EIA_CAMD2009[!is.na(EIA_CAMD2009[,'CO2_ton']) & EIA_CAMD2009[,'CO2_ton'] > 0, ]
# EIA_CAMD2009 <- EIA_CAMD2009[!duplicated(EIA_CAMD2009[, 'Plant Code']), ]
# EIA_CAMD2009[,7:9] <- round(EIA_CAMD2009[,7:9], digit = 3)
# 
# rm(dt); invisible(gc())
# 
# ## this is used to set the icoType in gvisMotionChart
# ## the format should be exactly like this to set 'LINE' as the default icoType
# ## it is equal to '\n{\"iconType\":\"LINE\"}\n', which is print(myIcoTypeSetting)
# myIcoTypeSetting <-'
# {"iconType":"LINE"}
# '
# save(list = ls(), file='global.rda')
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
