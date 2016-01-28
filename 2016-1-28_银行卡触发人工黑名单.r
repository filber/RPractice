source("GraphicUtil.r",encoding = "UTF-8")
source("DataUtil.r",encoding = "UTF-8")

#该卡触发了黑名单,尾号为0617
card<-c("F28E54F934831D525AC94FD9EE108213866A904E")

phone<-link_Card_2_Phone(card)
phone<-recursiveLink_Phone_2_Phone(phone,maxLoopCount = 4)
card<-link_Phone_2_Card(phone)

findResult <- searchIVRRiskDB(query = query_card(card))

draw_IVR_Trace(findResult)