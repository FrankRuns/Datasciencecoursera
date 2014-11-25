Activity Monitoring Device Data Project
========================================================

Utilizing data from a personal activity monitoring device, this analysis attempts to answer several questions about patterns in the number of steps taken by an individual over the course of 2 months; October and Novermber 2012.

Load all necessary packages here.

```r
library(Hmisc)
```

```
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
## Loading required package: splines
## Loading required package: Formula
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```

```r
library(lattice)
library(plyr)
```

```
## 
## Attaching package: 'plyr'
## 
## The following objects are masked from 'package:Hmisc':
## 
##     is.discrete, summarize
```


## Loading and Preprocessing the Data
We begin by loading and reading the data and changing the dates into workable dates.


```r
url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(url, destfile = ("./newfile.zip"), method = "curl")
unzip("newfile.zip")
data <- read.csv("activity.csv")
dates <- data$date
dates <- as.Date(as.character(dates), "%Y-%m-%d")
data$date <- dates
```


At this point, the data is sufficiently ready for analysis and to help us answer our questions. 

## What is mean total number of steps taken per day?
First, use the tapply function to plot a histogram of total number of steps each day and we see a pretty normal distribution.


```r
hist(tapply(data$steps, data$date, FUN = sum), breaks = 10, xlab = "# of Steps", 
    main = "Hist of Total # of Steps per Day")
```

![plot of chunk histogram](figure/histogram.png) 


Next we find the mean and median of total steps each day which come out to be about 9,354 and 10,765 respectively.


```r
meanSteps <- sum(data$steps, na.rm = TRUE)/length(unique(data$date))
meanSteps
```

```
## [1] 9354
```

```r
medSteps <- (aggregate(steps ~ date, data = data, FUN = sum))
median(medSteps$steps)
```

```
## [1] 10765
```


## What is the average daily activity pattern?
We use a line chart showing the average # of steps in each time interval to discover the 5-minute interval that has the highest average steps is a little bit before 2PM.


```r
intervalData <- aggregate(steps ~ interval, data = data, FUN = mean)
plot(intervalData, type = "l", xlab = "5-minute Interval", ylab = "Number of Steps", 
    main = "Average # of Steps per 5-minute Interval")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 

```r
findMax <- subset(intervalData, intervalData$steps == max(intervalData$steps))
findMax
```

```
##     interval steps
## 104      835 206.2
```


## Imputing missing values
Since the rate of occurance of NA values is about 13% --- quite high --- we use a simple mean method to impute these missing values. We can see from the boxplot below that this system spreads teh data out a little more since the mean is about 10,000 and we have a lot of zero values. This is not ideal and granted more time, I would consider using a better imputation package such as VIM. 


```r
sum(is.na(data))/nrow(data)
```

```
## [1] 0.1311
```

```r
data$imputed_steps <- with(data, impute(steps, mean))
hist(tapply(data$imputed_steps, data$date, FUN = sum), breaks = 10, xlab = "# of Steps", 
    main = "Hist of Total # of Steps per Day with Imputed Value")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-21.png) 

```r
impMean <- aggregate(imputed_steps ~ date, data = data, FUN = mean)
impMedian <- aggregate(imputed_steps ~ date, data = data, FUN = median)
boxplot(data$steps, data$imputed_steps)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-22.png) 


## Are there differences in activity patterns between weekdays and weekends?
Using the lattice and plyr packages, we convert dates into weekends/weekdays to show that this individual took more steps on weekdays in November and took more steps on the weekends in October.


```r
data$weekend <- weekdays(data$date) == "Saturday" | weekdays(data$date) == "Sunday"
data$weekend <- as.factor(data$weekend)
data$weekend <- revalue(data$weekend, c(`TRUE` = "weekday", `FALSE` = "weekend"))
xyplot(imputed_steps ~ interval | weekend, data, type = "l", layout = c(1, 2))
```

![plot of chunk weekdays and weekends](figure/weekdays_and_weekends.png) 

