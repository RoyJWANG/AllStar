##### packages #####
rm(list=ls())
install.packages("tidyquant")
install.packages("lubridate")
library(tidyquant)
library(lubridate)
#####

#first we need to know the stock codes

##### single web scraping: to get PS, and them reshape it in to data frame #####
#Reading the HTML code from the website (need html or selector gadget)
# .pnum , .nnum , .num , .linkb
#first we scrap the 100 popular stocks
install.packages('rvest')
library('rvest')
url <- 'http://www.wsj.com/mdc/public/page/2_3021-activnyse-actives.html'
webpage <- read_html(url)
webpage
length(webpage)

Top100Stocks.html <- html_nodes(webpage,'.pnum , .nnum , .num , .linkb')
Top100Stocks <- html_text(Top100Stocks.html)
head(Top100Stocks)

Top100Stocks[7] # the "2" which should be on the second line is still in the 7th position of the first line
# we need to extract the data into 6 seperate vector and then combine it

# addtionally, we need to seperate Name and Code, using strsplit, end up with 7 columns in total
# single sample of extracting Code
Name1<-Top100Stocks[8]
Name1
RawCode<-strsplit(Name1, " \\(")
RawCode[[1]][2]
RawCode[[1]][1] #this can be used as names
NeatCode<-strsplit(RawCode[[1]][2], ")")
NeatCode[[1]][1]

#now using loop to combine it into vectors of Name and Code
Code<-rep(1,100)
Name<-rep(1,100)
for (i in 1:100){
  Name[i]<-Top100Stocks[i*6-4]
  RawCode<-strsplit(Name[i], "\\(")
  RawCode[[1]][2]
  Name[i]<-RawCode[[1]][1]
  NeatCode<-strsplit(RawCode[[1]][2], ")")
  Code[i]<-NeatCode[[1]][1]
}
print(Code)
print(Name)

# next we need to reshape the rest of data into dataframe, right now it is just one very long line

#Serial
Serial<-rep(1,100)
for (i in 1:100){
  Serial[i]<-Top100Stocks[i*6-5]
}
print(Serial)

#Volume
Volume<-rep(1,100)
for (i in 1:100){
  Volume[i]<-Top100Stocks[i*6-3]
}
print(Volume)

#Price
Price<-rep(1,100)
for (i in 1:100){
  Price[i]<-Top100Stocks[i*6-2]
}
print(Price) #find out we need to reform the first price
Price[1]<-"12.93"

#Change
Chg<-rep(1,100)
for (i in 1:100){
  Chg[i]<-Top100Stocks[i*6-1]
}
print(Chg)

#Pchange
Pchg<-rep(1,100)
for (i in 1:100){
  Pchg[i]<-Top100Stocks[i*6]
}
print(Pchg)

#convert string numbers into numeric
Volume
suppressWarnings(as.numeric(Volume)) # the Volume seems uneasy to convert into numeric, right now it's still string

Price
suppressWarnings(as.numeric(Price))
Chg
suppressWarnings(as.numeric(Chg))
Pchg
suppressWarnings(as.numeric(Pchg))

PS<-cbind(Serial, Name, Code, Volume, Price, Chg, Pchg)
dim(PS)
PS<-as.data.frame(PS)
colnames(PS)<-c('Serial', 'Name', 'Code', 'Volume', 'Price', 'Chg', 'Pchg')
#####

#now we know the stock codes, we can start pulling off history data

##### sample code of how we get the history stock prices for the past year, not necessarily needed in the final function #####
from <- today() - years(1)
Stock1 <- tq_get(PS[1,3], get = "stock.prices", from = from)
Stock1

##### loop to get a list of 100 stock prices #####
Stock<-list()
for (i in 1:100){
  from <- today() - years(1)
  Stock[[toString(PS[i,3])]]<- tq_get(PS[i,3], get = "stock.prices", from = from)
}

length(Stock)

#####

##### find out today's top 10 best performing stocks #####
#### (it is no meaning of capture all 100 stocks right?), 
#### and choose them to show their history prices for past 1 year
summary(PS)
PS$Pchg
PSsort<-PS[order(as.numeric(PS$Pchg)),] 
#here I use percentage change "`%change`" as performance index, this can be set as adjustable parameter too if you like
n<-7
TopPS_list<-PSsort[1:n,3]
TopPS_list

#### at this point we have 2 data files: 1) a list containing history price for 100 stocks, 
#### and 2) a list of stock codes sorted by their performance for today.
#####

##### url manipulation (May not useful but good to know)#####
#Specifying the url for desired website to be scrapped
urlx <- 'https://finance.yahoo.com/quote/xxxx/profile?p=xxxx'

#url manuplation example
url1<-gsub("xxxx", "BAC", urlx)
url1

#url manuplation loop/list
url<-list()

Scodes<-PS[,3]
Scodes
Scode1<-PS[1,3]

for (i in 1:100){
  url[[toString(PS[i,2])]]<-gsub("xxxx",toString(PS[i,3]),urlx)
}
url
##### 

##### visualization part (unfinished) #####
# take a look at the data structure first
Stock[["F"]]$close # we use the close price to draw curves

install.packages("ggplot2")
library(ggplot2)




#####






