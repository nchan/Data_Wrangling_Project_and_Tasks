library(RODBC)
library(sqldf)
library(ggplot2)
library(stringr)


myconn<-odbcConnect("dartmouth2", "nchan", "nchan@qbs181")

Flowsheets<-sqlQuery(myconn, "select * from dbo.Flowsheets")

Flowsheets$DISP_NAME<-gsub('cc/kg', 'CC-Kg', Flowsheets$DISP_NAME)

View(Flowsheets)

str_extract_all(Flowsheets, regex('[0-9A-Za-z]'))

symbolsOnly<-gsub('[[:alnum:]]', ' ', as.matrix(Flowsheets))


Provider<-sqlQuery(myconn, "select * from dbo.Provider")

install.packages("tidyr")
library(tidyr)
newProv<-separate(Provider, col = NEW_PROV_NAME, into = c('Last', 'First'), sep = ',( )?')
str_extract(newProv$Last, '^(W|w)a')


empty<-as.matrix(str_split_fixed(Provider$NEW_PROV_NAME, ',( )?', 2))
Provider$Last = empty[,1]
Provider$First=empty[,2]
Provider<-Provider[,-2]
str_extract(Provider$Last, '^(W|w)a')
