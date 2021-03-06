Most Harmful Weather Types in the US
========================================================

# Introduction

Using the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database, this analysis will identify which types of severe weather-related events are most harmful with respect to population health and economic prosperity. The data (csv file) can be downloaded [here](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2) and an explanation of how the data was collected (PDF) can be found [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf).

Due to changes in the collection process, only storms recorded after 1996 will be used. The top 2% of storms according to injuries, real-estate damage, and crop damage will be subset into a "mini" dataset along with storms with at least 1 fatalitiy for final analysis and concluding remarks. These will be refered to as 'determining factors.'

# Results

Begin by downloading and reading the data. Make sure the storms csv file above is unziped and in your working directory. In this case, the file is on my desktop.

```r
setwd("~/Desktop")
ocean <- read.csv("repdata-data-StormData.csv")
```


Take the data that the analysis requires and leave the rest behind. This will make computation times short. 

```r
ocean.m <- ocean[, c("BGN_DATE", "STATE", "EVTYPE", "FATALITIES", "INJURIES", 
    "PROPDMG", "CROPDMG", "LATITUDE", "LONGITUDE")]
dim(ocean.m)
```

```
## [1] 902297      9
```


NOAA only starts collecting data on all weather type events in 1996 [according to this](http://www.ncdc.noaa.gov/stormevents/details.jsp?type=eventtype). Utilizing data before this point would distort the analysis, so the analysis uses data beginning in 1996 --- giving us 18 years worth of data. To filter by date, we must convert the dates into date POSIX objects. 

```r
ocean.m$BGN_DATE <- strptime(ocean.m$BGN_DATE, format = "%m/%d/%Y %H:%M:%S")
ocean.m <- ocean.m[ocean.m$BGN_DATE > strptime("1996-01-01", format = "%Y-%m-%d"), 
    ]
dim(ocean.m)
```

```
## [1] 653507      9
```


It's good to examine missing values. A quick inspection of the enitre data shows that of the 33 million datapoints, about 1.7 million are missing (or 5%). Luckily, in the scaled downed dataset the percentage of missing values is closer to 0.

```r
entire_missing <- sum(is.na(ocean))
entire_datapoints <- dim(ocean)[1] * dim(ocean)[2]
entire_missing/entire_datapoints
```

```
## [1] 0.0523
```

```r
small_missing <- sum(is.na(ocean.m))
small_datapoints <- dim(ocean.m)[1] * dim(ocean.m)[2]
small_missing/small_datapoints
```

```
## [1] 7.991e-06
```


How will we define 'most farmful' storms? Instead of adding monetary and fatality values absolutely, this analysis will attempt to capture the opportunity cost associated with storms by creating a smaller subset of the data and then looking at which types occur most frequently. To create the smaller subset these are the criteria for each determining factors used to identify the most harmful storms. 1) Storms with at least 1 fatality. 2) Top 2% of storms by injuries. 3) Top 2% of storms by property damage (in monetary value). 4) Top 2% of storms by crop damage (in monetary value). Identify these sub datasets and combine with the rbind function. Finally, remove duplicate storms using the unique function. 

```r
# fatalities
ocean.s.fatalities <- subset(ocean.m, ocean.m$FATALITIES > 0)
# injuries
top5injuries <- max(ocean.m$INJURIES) * 0.98
ocean.s.injuries <- subset(ocean.m, ocean.m$INJURIES > top5injuries)
# real-estate damage
top5prop <- max(ocean.m$PROPDMG) * 0.98
ocean.s.prop <- subset(ocean.m, ocean.m$PROPDMG > top5prop)
# crop damage
top5crop <- max(ocean.m$CROPDMG) * 0.98
ocean.s.crop <- subset(ocean.m, ocean.m$CROPDMG > top5crop)
# combine it all
ocean.df <- rbind(ocean.s.fatalities, ocean.s.injuries, ocean.s.prop, ocean.s.crop)
dim(ocean.df)
```

```
## [1] 4966    9
```

```r
ready.data <- unique(ocean.df)
```


Now that we have a dataset of most harmful storms, let's see where these storms happen around the country. Alaska is left out since the number of storms is very small compared to the land area.

```r
par(mar = c(1, 1, 1, 1))
library(maps)
ready.data$LONGITUDE2 <- ready.data$LONGITUDE/100 * -1
ready.data$LATITUDE2 <- ready.data$LATITUDE/100
map(database = "world", regions = c("USA"), xlim = c(-130, -65), ylim = c(24, 
    50), col = gray(0.9), fill = TRUE)
points(ready.data$LONGITUDE2, ready.data$LATITUDE2, pch = 20, cex = 0.3, col = "red")
title(main = "Location of Most Harmful Storms")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 


The map shows us the south central US and the northeast US get most of the most harmful storms. However, closely looking at the state tables for number of events California, Illinois, Florida, and Texas have the most storms. Of course, adjusting for land area could change this. 

```r
t <- table(ready.data$STATE)
t[order(-t)]
```

```
## 
##  FL  TX  CA  IL  MO  PA  NC  AL  AR  TN  NY  CO  OK  OH  LA  NJ  MS  SC 
## 397 389 274 233 185 172 158 151 138 135 132 121 110 107 105 101 100  97 
##  GA  MI  WA  UT  KY  VA  KS  IN  AZ  WI  NV  PR  MD  MN  WV  GU  IA  AK 
##  94  90  90  88  86  85  84  81  74  71  66  66  62  55  51  49  45  44 
##  OR  MT  NM  WY  ID  ND  NE  CT  MA  SD  HI  NH  ME  VT  DE  AM  DC  AN 
##  44  43  42  41  33  33  32  30  25  23  22  20  19  17  15   9   8   7 
##  VI  AS  PZ  RI  LM  GM  LS  PH  LC  LE  LH  LO  MH  PK  PM  SL  ST  XX 
##   6   5   4   4   3   1   1   1   0   0   0   0   0   0   0   0   0   0
```


Some of the values on the table above (LC, LE, LH etc. as state abbreviations) tell us that there are a good deal of errors in the database... good to keep in mind.

Lastly, let's look at number of storms according to type. 

```r
length(unique(ready.data$EVTYPE))
```

```
## [1] 110
```


That's too many so let's take the types of events that happen the most (in this case storms that have over 100 occurences in the dataset)

```r
storm_table <- table(ready.data$EVTYPE)
worst <- sort(storm_table[storm_table > 100])
```


Finally, plot the storm table to see that lightning, followed by flash floods are the 'most harmful' types of storms.

```r
par(las = 2, mar = c(4, 12, 2, 2))  # make label text perpendicular to axis
barplot(worst, main = "Occurance of Most Harmful Storms", horiz = TRUE, col = "steelblue")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 


# Conclusion and Going Further

Using the NOAA storms database and the determining factors assumptions, we can conclude that lightning storms followed by flash floods and excessive heat are the most harmful weather event types assessing societal health and economic damage. To increase the reliability of this analysis several things can be improved. First, the economic determining factors can be adjusted for inflation. However, inflation in the US over the past 18 years has been very low. Second, the presence of 0 values might be addressed in a further study. Lastly, a destruction index can be created to sum all damage done from storms by type. For instance, lightning caused $5B worth of damage and 20 fatalities. In this analysis, volume of occurance assumed maximum damage over time because it includes the opportunity cost associated with stormy weather. However, this might not be the most accurate assessment. Despite these short comings, this analysis generates insightful knowledge for thinking about severe weather events.

