library(ggplot2)

draw_IVR_Trace<-function(findResult){
  #Draw Graphics
  p<-ggplot(findResult,aes(x = factor(substring(created,6,16)),y = payamt,group=1)) +
    geom_point(size=5,aes(shape=paytranresult)) +
    geom_line() +
    ylim(min(findResult$payamt)-100,max(findResult$payamt)+100) +
    geom_text(aes(label=bankcardmask,vjust=2),colour="red") +  #银行卡后四位
    geom_text(aes(label=substr(orderphone,8,11),vjust=-2)) +    #充值手机号后四位
    geom_text(aes(label=substr(rcgphone,8,11),vjust=4)) +       #被充值手机号后四位
    geom_text(aes(label=paste("¥",payamt,sep=""),vjust=-4),colour="blue") + #金额
    ylab("金额") + xlab("时间") +
    coord_fixed(ratio = 1/100)
  
  start_pivot<-1
  end_pivot<-2
  threshold<-3000
  splitLines<-c()
  while(end_pivot<length(findResult$created)){
    if(sd(findResult[start_pivot:end_pivot,]$created)>threshold){
      splitLines<-c(splitLines,end_pivot-0.5)
      p<-p+geom_vline(xintercept=end_pivot-0.5,linetype="dashed")    #时间分割线
      start_pivot<-end_pivot
      end_pivot<-end_pivot+1
    } else {
      end_pivot<-end_pivot+1
    }
  }
  p
}