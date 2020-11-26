library(stringr)
library(tidyr)
library(tidyverse)
library(RODBC)
library(sqldf)
install.packages("lubridate")
library(lubridate)


myconn<-odbcConnect("dartmouth2", "nchan", "nchan@qbs181")
Demographics<-sqlQuery(myconn, "select * from dbo.Demographics")
Demographics$tri_age[is.na(Demographics$tri_age)] <- mean(Demographics$tri_age, na.rm = TRUE)
#View(sample_n(Demographics, 10))
PhoneCall<-sqlQuery(myconn, "select * from dbo.PhoneCall")

times <- mdy_hm(PhoneCall$CallStartTime)
PhoneCall$callEndTime <- times+PhoneCall$CallDuration
