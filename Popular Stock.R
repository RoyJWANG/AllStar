#### Get stock prices
install.packages("tidyquant")
install.packages("lubridate")
library(tidyquant)
library(lubridate)

library(readr)
PS <- read_csv("~/Roy Practice/Popular Stocks.csv")
View(PS) #this is just a list of today's top 100 popular stocks, source: Wall Street Journal

#### sample code of how we get the history stock prices for the past year, not necessarily needed in the final function
from <- today() - years(1)
Stock1 <- tq_get(PS[1,3], get = "stock.prices", from = from)
Stock1

#### loop to get a list of 100 stock prices 
Stock<-list()
for (i in 1:100){
  from <- today() - years(1)
#  if(i==1){
  Stock[[toString(PS[i,3])]]<- tq_get(PS[i,3], get = "stock.prices", from = from)
#  } else {
#   Stock<-rbind(Stock,tq_get(PS[i,3], get = "stock.prices", from = from))
#  }  
}
View(Stock$BAC)
length(Stock)

#### find out today's top 10 best performing stocks 
#### (it is no meaning of capture all 100 stocks right?), 
#### and choose them to show their history prices for past 1 year

PSsort<-PS[order(PS$`%change`),] 
#here I use percentage change "`%change`" as performance index, this can be set as adjustable parameter too if you like
n<-10
TopPS_list<-PSsort[1:n,3]
TopPS_list

#### at this point we have 2 data files: 1) a list containing history price for 100 stocks, 
#### and 2) a list of stock codes sorted by their performance for today.
#### have fun playing with them using ggplot, cheers!