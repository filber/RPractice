library(RCurl)
library(ggplot2)
library(XML)
library(grid)
symbol<-commandArgs(trailingOnly = TRUE)[1]
stock_name<-commandArgs(trailingOnly = TRUE)[2]
startoffset<-ifelse(is.na(commandArgs(trailingOnly = TRUE)[3]),14,as.numeric(commandArgs(trailingOnly = TRUE)[3]))
startdate<-as.character.Date(Sys.Date()-startoffset,format="%Y%m%d")
url<-paste("http://market.finance.sina.com.cn/pricehis.php?symbol=",symbol,"&startdate=",startdate,sep = "");
response<-getURL(url = url,.encoding = "GBK")
responseXML<-xmlParse(substr(response,regexpr("<tbody>",response)[1],regexpr("</tbody>",response)[1]+7))

nodeSet<-getNodeSet(responseXML,"//tbody/tr/td")
price_data_frame<-data.frame()
for(i in seq(from=0,to=length(nodeSet)/3-1)){
  price_data_frame<-rbind(data.frame(
      price=as.numeric(xmlValue(nodeSet[i*3+1][[1]])),
      amount=as.numeric(xmlValue(nodeSet[i*3+2][[1]])),
      percent=as.numeric(gsub("\\%","",xmlValue(nodeSet[i*3+3][[1]])))/100
    ),price_data_frame)
}

stock_title<-paste(stock_name,"[",symbol,"]",startdate,".png",sep="")

p1<-ggplot(price_data_frame,aes(x=price,y=amount)) +geom_bar(position="dodge",stat="identity") +ggtitle(stock_title)
png(file = stock_title,width=800,height=600)
grid.newpage()
print(p1)
dev.off()
