NextWords
========================================================
author: Frank Corrigan
date: Decemeber 2014

Demonstration
========================================================

Page to show app... use iframe if possible in rpres

For more details on authoring R presentations click the
**Help** button on the toolbar.

- Bullet 1
- Bullet 2
- Bullet 3

High Level
========================================================

Talk about steps algorithm takes to predict.

Begin with large chunk of text -- tweets, blogs, news.
Clean up so we are focused only on the words -- remove punctuation, numbers, whitespace.
Create ngrams --- 5's, 4's, 3's, 2's and frequency of ngrams
Combine ngrams into dataframe in decsending order
Write to file to be read and used by shiny app


```r
summary(cars)
```

```
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  
```

Example
========================================================

tiny corpus
clean it 
make ngrams
table
to data.table
search for phrase and take most common

![plot of chunk unnamed-chunk-2](NextWords-figure/unnamed-chunk-2-1.png) 

Room for Improvement
========================================================
Speed
swearwords
Additional Features
      POS recognition
      Language recognition
      Add punctuation and emoticon prediction
      question answering (liek siri)
      practical application (perhaps into a simple word processor)
      
Summary
========================================================
App is good at predicting next word(s)
Speed and functionality can be improved
App provides solid foundation for creating practical application
