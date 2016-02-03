library(RJDBC)

#JDBC Driver
drv<-JDBC(driverClass = "oracle.jdbc.driver.OracleDriver",classPath = "C:/Users/Administrator/.m2/repository/com/oracle/ojdbc14/10.2.0.1.0/ojdbc14-10.2.0.1.0.jar",identifier.quote = "")
#JDBC Connection
con<-dbConnect(drv,"jdbc:oracle:thin:showoperate/sh0wop1rAT@192.168.11.141:1521:ora")

result<-dbGetQuery(con,"select * from t_pay_info where rownum < 10")


dbDisconnect(con)



dbpayCon<-dbConnect(drv,"jdbc:oracle:thin:appread/P2ssW0rd_AppRead@192.168.11.61:1521:dbpay")

result<-dbGetQuery(dbpayCon,"select * from PIONEER.P_PROVINCE")
