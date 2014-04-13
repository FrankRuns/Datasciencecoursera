# Getting & Cleaning Data Wk1 Notes
===============================================

Check For and/or Create Directory/File
-----------------------------------------------
file.exists("directory name") ## will check to see if there is a directory by that name
dir.create("directory name") ## will create a new dir in current working directory

Check for file, if it doesn't exist create it
-----------------------------------------------
if (!file.exists("datafile")){
        dir.create("datafile")
}

Download a file from internet (better for reporducability) with download.file()
-----------------------------------------------
* fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
* download.file(fileUrl, destfile="./datasciencecoursera/cameras.csv", method="curl")
* list.files("datasciencecoursera")
* dateDownloaded <- date()

Read that data you downloaded from internet
-----------------------------------------------
cameraData <- read.table("cameras.csv", header=TRUE, sep=",")

Read xml files with XML package
-----------------------------------------------
* install.packages("XML")
* library(XML)
* xUrl <- "http://www.w3schools.com/xml/simple.xml"
* doc <- xmlTreeParse(xUrl, useInternal=TRUE)
* rootNode <- xmlRoot(doc) # wrapper element for entire doc
* xmlName(rootNode) # gives you actual name
* names(rootNode) # shows you all tags under xmlName
* rootNode[[1]] # shows you everything about first node
* rootNode[[1]][[1]] # 1st subcomponent of 1st sub component
* xmlSApply(rootNode, xmlValue) # all text in doc

Moving into xpath language
-----------------------------------------------
* xpathSApply(rootNode,"//name",xmlValue)
* xpathSApply(rootNode,"//price",xmlValue)

Baltimore ravens xml example
-----------------------------------------------
* url <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
* doc <- htmlTreeParse(url, useInternal=TRUE) # notice the html tree parse
* scores <- xpathSApply(doc, "//li[@class='score']",xmlValue)
* teams <- xpathSApply(doc, "//li[@class='team-name']",xmlValue)
* scores # to actually view scores

Read json files with jsonlite package
-----------------------------------------------
* install.packages("jsonlite")
* library(jsonlite)
* jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
* names(jsonData)
* names(jsonData$owner)
* jsonData$owner$login

Using data.table
-----------------------------------------------
* install.packages("data.table")
* library(data.table)
* DF = data.frame(x=rnorm(9), y=rep(c("a","b","c"),each=3),z=rnorm(9))
* DT = data.table(x=rnorm(9), y=rep(c("a","b","c"),each=3),z=rnorm(9))
* tables() # views tables in workspace
* DT[2,] # subset first two rows
* DT[DT$y=="a",] # subset all rows where y == a
* DT[c(2,3)] # subset rows 2 and 3
* DT[,c(2,3)] # subset columns
* DT[,list(mean(x), sum(z))] # summarize data
* DT[,table(y)] # summarize data
* DT[,w:=z^2] # add new variable to data table, no new copy created!!!
* DT2 <- DT
* DT[,y:=2] # change first data table --- this will change both tables!!!!
# must use a copy function instead

* DT[,m:={tmp<-(x+z); log2(tmp+5)}] multi step operations are easy
* DT[,a:=x>0]
* DT[,b:=mean((x+w),by=a)]
* DT[,.N,by=x] # counts # of times variable occurs

# using keys
* DT <- data.table(x=rep(c("a","b","c"),each=100), ynorm=(300))
* setkey(DT, x)
* DT['a']

# keys and joins
* DT1 <- data.table(x=c('a','a','b','dt1'), y=1:4)
* DT2 <- data.table(x=c('a','b','dt2'), z=5:7)
* setkey(DT1,x); setkey(DT2,x)
* merge(DT1,DT2)