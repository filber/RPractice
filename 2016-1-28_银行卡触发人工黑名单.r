source("GraphicUtil.r",encoding = "UTF-8")
source("DataUtil.r",encoding = "UTF-8")

#该卡触发了黑名单,尾号为0617
card<-c("F28E54F934831D525AC94FD9EE108213866A904E")

phone<-link_Card_2_Phone(card)
phone<-recursiveLink_Phone_2_Phone(phone,maxLoopCount = 4)
card<-link_Phone_2_Card(phone)

findResult <- searchIVRRiskDB(query = query_card(card))

draw_IVR_Trace(findResult)

#验证facet_grid的样式
ggplot(findResult,aes(x=factor(created),y=payamt,group=1)) +
  geom_line() +
  geom_vline(xintercept=7.5,linetype="dashed")  +  #时间分割线
  geom_point(size=5,aes(shape=paytranresult)) +
  geom_text(aes(label=substr(orderphone,8,11),vjust=-2)) +    #充值手机号后四位
  geom_text(aes(label=substr(rcgphone,8,11),vjust=2)) +       #被充值手机号后四位
  facet_grid(bankcardmask ~ .,labeller=label_both)