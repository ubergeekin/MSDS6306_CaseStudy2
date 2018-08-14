# References: https://www.transportation.gov/sites/dot.dev/files/docs/Costs%20of%20Surface%20Transportation%20Congestion.pdf

library(broom)
library(dplyr)
library(kableExtra)
library(varhandle)
getwd()
setwd("D:\\Documents\\SMU\\DoingDataScience\\Homework\\CaseStudy2\\MSDS6306_CaseStudy2-master\\")
list.files()

# Read income data from CSV
income <- read.csv("Median Adjusted Gross Income by County - All Tax Filers.csv")

# find LA and Ventura counties that make up district 7
la <- grep("Los Angeles", income$County)
vent <- grep("Ventura", income$County)

# Assign LA and Ventura counties to income variable
income <- (income[c(la,vent),])

# Assign Median Income values to district 7 variable
dis7.income <- (income$Median.Income)
head(dis7.income)

# Strip unwanted $ and , from values
dis7.income <- gsub('\\$', '', dis7.income)
dis7.income <- gsub(',', '', dis7.income)
head(dis7.income)

# Convert values to numeric
dis7.income <- as.numeric(dis7.income)

# Calcualte the average income
dis7.income <- mean(dis7.income)

# Read gasoline prices CSV into the gas variable
gas <- read.csv("Weekly_California_All_Grades_All_Formulations_Retail_Gasoline_Prices.csv")
names(gas) <- c('Week of','Price')
gas$Price <- as.numeric(paste(gas$Price))
gas
summary(gas$Price)
mean(gas$Price, na.rm = TRUE)

# ************************** BEGIN EQUATIONS  **************************#
# Equation Conversions with Consolidated_traffic_data.csv #

# Read in the consolidated traffic data file
consolidated <- read.csv("consolidated_traffic_data.csv")

# Calculate the mean of delays
delays <- as.numeric(consolidated$avg_delay_35, consolidated$avg_delay_40, consolidated$avg_delay_45, consolidated$avg_delay_50, consolidated$avg_delay_55, consolidated$avg_delay_60)
delays <- mean(delays)
delays

# Average speed vector defined by delay data
avgspd <- c(35,40,45,50,55,60)

# Calculate fuel economy at acceleration
acceleration <- c((.068*60), (.071*60), (.072*60), (.075*60), (.074*60)) # Data from https://nepis.epa.gov/Exe/ZyNET.exe/9100WZVZ.txt?ZyActionD=ZyDocument&Client=EPA&Index=1976%20Thru%201980&Docs=&Query=&Time=&EndTime=&SearchMethod=1&TocRestrict=n&Toc=&TocEntry=&QField=&QFieldYear=&QFieldMonth=&QFieldDay=&UseQField=&IntQFieldOp=0&ExtQFieldOp=0&XmlQuery=&File=D%3A%5CZYFILES%5CINDEX%20DATA%5C76THRU80%5CTXT%5C00000019%5C9100WZVZ.txt&User=ANONYMOUS&Password=anonymous&SortMethod=h%7C-&MaximumDocuments=1&FuzzyDegree=0&ImageQuality=r75g8/r75g8/x150y150g16/i425&Display=hpfr&DefSeekPage=x&SearchBack=ZyActionL&Back=ZyActionS&BackDesc=Results%20page&MaximumPages=1&ZyEntry=2#
acceleration <- mean(acceleration)
acceleration

# Calculate average fuel economy at idle
idle <- c(.16, .39, .17, .84, .84, .59, .44, .97, .49, .90, .64) # Data from https://www.energy.gov/eere/vehicles/fact-861-february-23-2015-idle-fuel-consumption-selected-gasoline-and-diesel-vehicles
idle <- mean(idle)
idle

# Calculate average fuel economy average of acceleration and idle
esfc <- mean(acceleration, idle)
esfc

# Estimation of fuel consumption: Average MPG = (Avg Fuel Economy of Acceleration and Idle) + 0.25 (Compensation for Drag Coefficient) * Average Speed
AvgMPG <- (esfc+.025*avgspd)
names(AvgMPG) <- c("35-MPH", "40-MPH", "45-MPH", "50-MPH", "55-MPH", "60-MPH")
AvgMPG <- mean(AvgMPG)
AvgMPG


# Travel Time Cost Equation: Travel Time in peak congestion period = Daily VHT in peak congestion/Daily VMT in peak congestion
# Define VMT
vmt <- na.omit(as.numeric(paste(consolidated$annual_vmt)))
vmt <- mean(vmt)
vmt

# Define VHT
vht.raw <- na.omit(consolidated$avg_back_peak_hour, + consolidated$avg_back_peak_hour, + consolidated$avg_back_peak_month, + consolidated$avg_back_peak_hour)
vht <- mean(vht.raw)
vht

# Calculate Travel Time in Peak Congestion Period
ttpc <- vht / vmt
ttpc <- format(ttpc, scientific = FALSE)
print(paste("Travel Time in Peak Congestion Period:", ttpc))

# Calculate Unreliability Var = S0 + S1 - S0 / 1 + exp(b(v/c -a))
var <- 

# Calculate Reduced Mobility: C = Time Cost + Vehicle Operating Cost + Reliability Cost
mobility <= tc + voc + rc


# Calculate Marginal Cost of Driving (TC = AC * Q)
tc <- ac * vmt

# ************************** END EQUATIONS  **************************#      