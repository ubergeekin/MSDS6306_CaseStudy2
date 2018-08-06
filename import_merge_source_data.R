
#-------------------------------------------
# TRAFFIC VOLUME DATA FROM CALTRANS
# http://www.caltrans.ca.gov/
#-------------------------------------------
traffic.volumes <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2007.csv")
traffic.volumes$year <- "2007"
temp <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2008.csv")
temp$year <- "2008"
traffic.volumes <- rbind(traffic.volumes,temp)
temp <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2009.csv")
temp$year <- "2009"
traffic.volumes <- rbind(traffic.volumes,temp)
temp <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2010.csv")
temp$year <- "2010"
traffic.volumes <- rbind(traffic.volumes,temp)

#2011 data does not contain the same structure as those in 2010 and prior
traffic.volumes2 <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2011.csv")
traffic.volumes2$year <- "2011"
temp2 <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2012_0.csv")
temp2$year <- "2012"
traffic.volumes2 <- rbind(traffic.volumes2,temp2)
temp2 <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2013.csv")
temp2$year <- "2013"
traffic.volumes2 <- rbind(traffic.volumes2,temp2)
temp2 <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2014.csv")
temp2$year <- "2014"
traffic.volumes2 <- rbind(traffic.volumes2,temp2)
temp2 <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2015.csv")
temp2$year <- "2015"
traffic.volumes2 <- rbind(traffic.volumes2,temp2)
temp2 <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-traffic-volumes-All-2018-07-31_1534/caltrans-traffic-volumes-2016.csv")
temp2$year <- "2016"
traffic.volumes2 <- rbind(traffic.volumes2,temp2)

#remove latitude and longitude to fit modern table structure and bind all volume data
traffic.volumes <- traffic.volumes[,-15:-16]
traffic.volumes <- rbind(traffic.volumes,traffic.volumes2)
remove(temp)
remove(temp2)
remove(traffic.volumes2)

# rename column names to improve readability
colnames(traffic.volumes) <- c("caltrans_district","route_number","route_suffix","county","postmile_prefix","postmile_number","postmile_suffix","location","back_peak_hour","back_peak_month","back_AADT","ahead_peak_hour","ahead_peak_month","ahead_AADT","year")
write.csv(traffic.volumes,"traffic_volumes.csv")

#-------------------------------------------
# TRAFFIC DELAY DATA FROM CALTRANS
# http://www.caltrans.ca.gov/
#-------------------------------------------
#traffic.delays <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-annual-vehicle-delay-All-2018-07-31_1534/Caltrans_Annual_Vehicle_Hours_of_Delay_at_35_miles_per_hour___Vehicle_Miles_Traveled_2014.csv")
#traffic.delays$year <- "2014" 
#temp <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-annual-vehicle-delay-All-2018-07-31_1534/Caltrans_Annual_Vehicle_Hours_of_Delay_at_35_miles_per_hour___Vehicle_Miles_Traveled_2015.csv")
#temp$year <- "2015"
#traffic.delays <- rbind(traffic.delays,temp)
#temp <- read.csv("~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/caltrans-annual-vehicle-delay-All-2018-07-31_1534/Caltrans_Annual_Vehicle_Hours_of_Delay_at_35_miles_per_hour___Vehicle_Miles_Traveled_2016.csv")
#temp$year <- "2016"
#traffic.delays <- rbind(traffic.delays,temp)

# VHD = vehicles hours of delay
# VMT = vehicles miles traveled
# rename column names to improve readability
#colnames(traffic.delays) <- c("route_number","route_suffix","county","vhd_rank","annual_vhd_35","annual_vmt","year")
#remove(temp)

#-------------------------------------------
# TRAFFIC DELAY DATA FROM PEMS
# http://pems.dot.ca.gov
#-------------------------------------------
td_year <- list()
filepath= "~/Documents/Personal/MS SMU/MSDS 6306 Doing Data Science 402/Case Study 2/raw_data/"
for (i in 7:16) { # 7 thru 16
  if (i < 10) { 
    i <- paste0("0",i)
  }
  year <- paste0("20",i)
  #cat(year)
  location <- paste0(filepath,year)
  for (j in 1:12){
    if (j < 10) { 
      j <- paste0("0",j)
    }
    filename <- paste0("/d07_text_station_day_",year,"_",j,".txt")
    #cat(paste0(location,filename))
    path <- paste0(location,filename)
    cat(path)
    if(j > 1){
      temp2 <- read.csv(path)
      temp2$year <- year
      colnames(temp2) <- colnames(temp)
      ds <- rbind(temp,temp2)
    }else{
      temp <- read.csv(path)
      temp$year <- year
    }
  }
  td_year[[as.numeric(i)]] <- ds # td_year ([200]7 thru [20]16) is a list of datasets each containing 12 months of delays
}

for (i in 7:16){
  colnames(td_year[[i]]) <- c("Timestamp","Station","District","Route","Direction of Travel","Lane Type","Station Length","Samples","% Observed","Total Flow","Delay_35","Delay_40","Delay_45","Delay_50","Delay_55","Delay_60","year")
}

traffic.delays <- rbind(td_year[[7]],td_year[[8]])
for (i in 9:16){
  traffic.delays <- rbind(traffic.delays,td_year[[i]])
}

write.csv(traffic.delays,"traffic_delays.csv")
