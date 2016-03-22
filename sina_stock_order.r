library(RCurl)
library(mongolite)

con <- mongo(collection = "stock",url = 'mongodb://localhost:27017/stock')
retrieveData<- function(){
  stocks<-commandArgs(trailingOnly = TRUE)[1]
  #stocks<-'sh600516'
  response<-getURL(url = paste("http://hq.sinajs.cn/list=",stocks,sep = ""))
  response_vector<-strsplit(response,',')[[1]]
  for(i in seq(from = 0,to = length(strsplit(stocks,",")[[1]])-1)){
    offset<-i*32
    #代码
    start_index<-regexpr("hq_str_",response_vector[offset+1])[1]+7
    record<-data.frame(code=substr(x = response_vector[offset+1],start = start_index,stop = start_index+7))
    #日期
    record$data_date<-response_vector[offset+31]
    #时间
    record$data_time<-response_vector[offset+32]
    #开盘价
    record$open_price<-as.numeric(response_vector[offset+2])
    #昨日收盘价
    record$yesterday_close_price<-as.numeric(response_vector[offset+3])
    #当前价格
    record$current_price<-as.numeric(response_vector[offset+4])
    #今日最高价
    record$highest_price<-as.numeric(response_vector[offset+5])
    #今日最低价
    record$lowest_price<-as.numeric(response_vector[offset+6])
    #成交量
    record$tody_count<-as.numeric(response_vector[offset+9])
    #成交额
    record$tody_amount<-as.numeric(response_vector[offset+10])
    #五档买盘
    record$buy_order_count_1<-as.numeric(response_vector[offset+11])/100
    record$buy_order_price_1<-as.numeric(response_vector[offset+12])
    record$buy_order_count_2<-as.numeric(response_vector[offset+13])/100
    record$buy_order_price_2<-as.numeric(response_vector[offset+14])
    record$buy_order_count_3<-as.numeric(response_vector[offset+15])/100
    record$buy_order_price_3<-as.numeric(response_vector[offset+16])
    record$buy_order_count_4<-as.numeric(response_vector[offset+17])/100
    record$buy_order_price_4<-as.numeric(response_vector[offset+18])
    record$buy_order_count_5<-as.numeric(response_vector[offset+19])/100
    record$buy_order_price_5<-as.numeric(response_vector[offset+20])
    #五档卖盘
    record$sell_order_count_1<-as.numeric(response_vector[offset+21])/100
    record$sell_order_price_1<-as.numeric(response_vector[offset+22])
    record$sell_order_count_2<-as.numeric(response_vector[offset+23])/100
    record$sell_order_price_2<-as.numeric(response_vector[offset+24])
    record$sell_order_count_3<-as.numeric(response_vector[offset+25])/100
    record$sell_order_price_3<-as.numeric(response_vector[offset+26])
    record$sell_order_count_4<-as.numeric(response_vector[offset+27])/100
    record$sell_order_price_4<-as.numeric(response_vector[offset+28])
    record$sell_order_count_5<-as.numeric(response_vector[offset+29])/100
    record$sell_order_price_5<-as.numeric(response_vector[offset+30])
    #存数据库
    if(record$buy_order_price_1!=0 || record$sell_order_price_1!=0){
      try(expr = {con$insert(record)},silent = TRUE)  
    }
  }
}
while(TRUE) {
  try(retrieveData(),silent = FALSE)
  Sys.sleep(1)
}