library(RCurl)
library(mongolite)

con <- mongo(collection = "stock",url = 'mongodb://localhost:27017/stock')


while(TRUE) {
Sys.sleep(1)
response<-getURL(url = "http://hq.sinajs.cn/list=sh600516")
response_vector<-strsplit(response,',')[[1]]
#代码
record$code<-substr(x = response,start = 12,stop = 19)
#日期
record$data_date<-response_vector[31]
#时间
record$data_time<-response_vector[32]
#开盘价
record$open_price<-as.numeric(response_vector[2])
#昨日收盘价
record$yesterday_close_price<-as.numeric(response_vector[3])
#当前价格
record$current_price<-as.numeric(response_vector[4])
#今日最高价
record$highest_price<-as.numeric(response_vector[5])
#今日最低价
record$lowest_price<-as.numeric(response_vector[6])
#成交量
record$tody_count<-as.numeric(response_vector[9])
#成交额
record$tody_amount<-as.numeric(response_vector[10])
#五档买盘
record$buy_order_price_1<-as.numeric(response_vector[11])
record$buy_order_count_1<-as.numeric(response_vector[12])
record$buy_order_price_2<-as.numeric(response_vector[13])
record$buy_order_count_2<-as.numeric(response_vector[14])
record$buy_order_price_3<-as.numeric(response_vector[15])
record$buy_order_count_3<-as.numeric(response_vector[16])
record$buy_order_price_4<-as.numeric(response_vector[17])
record$buy_order_count_4<-as.numeric(response_vector[18])
record$buy_order_price_5<-as.numeric(response_vector[19])
record$buy_order_count_5<-as.numeric(response_vector[20])
#五档卖盘
record$sell_order_price_1<-as.numeric(response_vector[21])
record$sell_order_count_1<-as.numeric(response_vector[22])
record$sell_order_price_2<-as.numeric(response_vector[23])
record$sell_order_count_2<-as.numeric(response_vector[24])
record$sell_order_price_3<-as.numeric(response_vector[25])
record$sell_order_count_3<-as.numeric(response_vector[26])
record$sell_order_price_4<-as.numeric(response_vector[27])
record$sell_order_count_4<-as.numeric(response_vector[28])
record$sell_order_price_5<-as.numeric(response_vector[29])
record$sell_order_count_5<-as.numeric(response_vector[30])
try(expr = {con$insert(record)},silent = TRUE)
}