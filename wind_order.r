library(WindR)
library(RCurl)
library(mongolite)


retrieveData<- function(){
  for(i in seq(from = 1,to = length(stock_vector))){
    w_wsq_data<-w.wsq(stock_vector[i],"
                      rt_date,rt_time,rt_open,rt_pre_close,
                      rt_high,rt_low,rt_last,rt_last_amt,rt_last_vol,rt_latest,
                      rt_vol,rt_amt,
                      rt_chg,rt_pct_chg,rt_swing,rt_vwap,rt_pct_chg_1min,rt_pct_chg_3min,rt_vol_ratio,
                      rt_ask1,rt_ask2,rt_ask3,rt_ask4,rt_ask5,rt_ask6,rt_ask7,rt_ask8,rt_ask9,rt_ask10,rt_bid1,rt_bid2,rt_bid3,rt_bid4,rt_bid5,rt_bid6,rt_bid7,rt_bid8,rt_bid9,rt_bid10,rt_bsize1,rt_bsize2,rt_bsize3,rt_bsize4,rt_bsize5,rt_bsize6,rt_bsize7,rt_bsize8,rt_bsize9,rt_bsize10,rt_asize1,rt_asize2,rt_asize3,rt_asize4,rt_asize5,rt_asize6,rt_asize7,rt_asize8,rt_asize9,rt_asize10")
    
    #代码
    record<-data.frame(code=stock_vector[i])
    #日期
    record$data_date<-w_wsq_data$Data$RT_DATE
    #时间
    record$data_time<-w_wsq_data$Data$RT_TIME
    #开盘价
    record$open_price<-w_wsq_data$Data$RT_OPEN
    #前日收盘价
    record$pre_close<-w_wsq_data$Data$RT_PRE_CLOSE
    #当前价格
    record$current_price<-w_wsq_data$Data$RT_LAST
    #今日最高价
    record$highest_price<-w_wsq_data$Data$RT_HIGH
    #今日最低价
    record$lowest_price<-w_wsq_data$Data$RT_LOW
    #最后成交量
    record$last_vol<-w_wsq_data$Data$RT_LAST_VOL
    #最后成交额
    record$last_amt<-w_wsq_data$Data$RT_LAST_AMT
    #成交量
    record$vol<-w_wsq_data$Data$RT_VOL
    #成交额
    record$amt<-w_wsq_data$Data$RT_AMT
    #涨跌
    record$chg<-w_wsq_data$Data$RT_CHG
    #涨跌幅
    record$pct_chg<-w_wsq_data$Data$RT_PCT_CHG
    #振幅
    record$swing<-w_wsq_data$Data$RT_SWING
    #均价
    record$vwap<-w_wsq_data$Data$RT_VWAP
    #量比
    record$vol_ratio<-w_wsq_data$Data$RT_VOL_RATIO
    #1分钟涨幅
    record$chg_1min<-w_wsq_data$Data$RT_PCT_CHG_1MIN
    #3分钟涨幅
    record$chg_3min<-w_wsq_data$Data$RT_PCT_CHG_3MIN
    #十档买盘
    record$buy_order_count_1<-w_wsq_data$Data$RT_BSIZE1/100
    record$buy_order_price_1<-w_wsq_data$Data$RT_BID1
    record$buy_order_count_2<-w_wsq_data$Data$RT_BSIZE2/100
    record$buy_order_price_2<-w_wsq_data$Data$RT_BID2
    record$buy_order_count_3<-w_wsq_data$Data$RT_BSIZE3/100
    record$buy_order_price_3<-w_wsq_data$Data$RT_BID3
    record$buy_order_count_4<-w_wsq_data$Data$RT_BSIZE4/100
    record$buy_order_price_4<-w_wsq_data$Data$RT_BID4
    record$buy_order_count_5<-w_wsq_data$Data$RT_BSIZE5/100
    record$buy_order_price_5<-w_wsq_data$Data$RT_BID5
    record$buy_order_count_6<-w_wsq_data$Data$RT_BSIZE6/100
    record$buy_order_price_6<-w_wsq_data$Data$RT_BID6
    record$buy_order_count_7<-w_wsq_data$Data$RT_BSIZE7/100
    record$buy_order_price_7<-w_wsq_data$Data$RT_BID7
    record$buy_order_count_8<-w_wsq_data$Data$RT_BSIZE8/100
    record$buy_order_price_8<-w_wsq_data$Data$RT_BID8
    record$buy_order_count_9<-w_wsq_data$Data$RT_BSIZE9/100
    record$buy_order_price_9<-w_wsq_data$Data$RT_BID9
    record$buy_order_count_10<-w_wsq_data$Data$RT_BSIZE10/100
    record$buy_order_price_10<-w_wsq_data$Data$RT_BID10
    #十档卖盘
    record$sell_order_count_1<-w_wsq_data$Data$RT_ASIZE1/100
    record$sell_order_price_1<-w_wsq_data$Data$RT_ASK1
    record$sell_order_count_2<-w_wsq_data$Data$RT_ASIZE2/100
    record$sell_order_price_2<-w_wsq_data$Data$RT_ASK2
    record$sell_order_count_3<-w_wsq_data$Data$RT_ASIZE3/100
    record$sell_order_price_3<-w_wsq_data$Data$RT_ASK3
    record$sell_order_count_4<-w_wsq_data$Data$RT_ASIZE4/100
    record$sell_order_price_4<-w_wsq_data$Data$RT_ASK4
    record$sell_order_count_5<-w_wsq_data$Data$RT_ASIZE5/100
    record$sell_order_price_5<-w_wsq_data$Data$RT_ASK5
    record$sell_order_count_6<-w_wsq_data$Data$RT_ASIZE6/100
    record$sell_order_price_6<-w_wsq_data$Data$RT_ASK6
    record$sell_order_count_7<-w_wsq_data$Data$RT_ASIZE7/100
    record$sell_order_price_7<-w_wsq_data$Data$RT_ASK7
    record$sell_order_count_8<-w_wsq_data$Data$RT_ASIZE8/100
    record$sell_order_price_8<-w_wsq_data$Data$RT_ASK8
    record$sell_order_count_9<-w_wsq_data$Data$RT_ASIZE9/100
    record$sell_order_price_9<-w_wsq_data$Data$RT_ASK9
    record$sell_order_count_10<-w_wsq_data$Data$RT_ASIZE10/100
    record$sell_order_price_10<-w_wsq_data$Data$RT_ASK10
    
    #存数据库
    if(record$buy_order_price_1!=0 || record$sell_order_price_1!=0){
      try(expr = {con$insert(record)},silent = TRUE)  
    }
  }
}

con <- mongo(collection = "stock",url = 'mongodb://localhost:27017/stock')
w.start(showmenu=FALSE);
stock_vector<-strsplit(commandArgs(trailingOnly = TRUE)[1],',')[[1]]
while(TRUE) {
  if(!w.isconnected())w.start(showmenu = FALSE)
  try(retrieveData(),silent = FALSE)
  Sys.sleep(1)
}

w.stop()

